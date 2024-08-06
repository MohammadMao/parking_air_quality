#include <Wire.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include <ESP32Servo.h>
#include "MQUnifiedsensor.h"

#define MQTT_MAX_PACKET_SIZE 128
#define MQTT_PACKET_SIZE 512

#define RELAY_PIN 5
#define PIR_SENSOR_PIN_1 2
#define PIR_SENSOR_PIN_2 15
#define SERVO_PIN 26
#define MQ2_PIN 34  // Analog pin where the MQ2 sensor is connected

Servo doorServo;
bool doorOpen = false;
unsigned long doorOpenTime = 0;
bool automaticFanControl = true;
bool manualFanControl = false;
bool manualFanOn = false;

const char* ssid = "";
const char* password = "";
const char* mqttServer = "broker.hivemq.com";
const int mqttPort = 1883;
const char* mqttUser = "";
const char* mqttPassword = "";
const char* clientId = "ESP32Client-";
const char* doorStatusTopic = "door/status";
const char* fanStatusTopic = "fan/status";
const char* fanControlTopic = "control/fan";
const char* smokeTopic = "smoke/level";
const char* coTopic = "co/level";
const char* fanManualTopic = "control/fan/manual";

WiFiClient espClient;
PubSubClient client(espClient);
MQUnifiedsensor gasSensor("ESP32", 3.3, 12, MQ2_PIN, "MQ-2");

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  if (String(topic) == fanControlTopic && length == 1) {
    bool controlMode = payload[0] == '1'; // Check if the payload is '1' (automatic) or '0' (manual)
    automaticFanControl = controlMode;
    manualFanControl = !controlMode; // Disable the opposite mode
    Serial.print("Fan control mode set to: ");
    Serial.println(controlMode ? "automatic" : "manual");

    if (automaticFanControl) {
      digitalWrite(RELAY_PIN, LOW); // Ensure fan is off when switching to automatic mode
      client.publish(fanStatusTopic, "automatic", true);
      Serial.println("Switched to automatic fan control mode.");
    } else {
      // Publish the current manual fan control status
      if (manualFanOn) {
        digitalWrite(RELAY_PIN, HIGH); // Turn on fan if it was on before
        client.publish(fanStatusTopic, "working", true);
      } else {
        digitalWrite(RELAY_PIN, LOW); // Turn off fan if it was off before
        client.publish(fanStatusTopic, "not working", true);
      }
      Serial.println("Switched to manual fan control mode.");
    }
  } else if (String(topic) == fanManualTopic && length == 1 && manualFanControl) {
    manualFanOn = (payload[0] == '1'); // '1' to turn on, '0' to turn off manually
    if (manualFanOn) {
      digitalWrite(RELAY_PIN, HIGH); // Turn on fan
      client.publish(fanStatusTopic, "working", true);
      Serial.println("Fan turned on manually.");
    } else {
      digitalWrite(RELAY_PIN, LOW); // Turn off fan
      client.publish(fanStatusTopic, "not working", true);
      Serial.println("Fan turned off manually.");
    }
  }
}

void reconnect() {
  if (WiFi.status() != WL_CONNECTED) {
    setup_wifi();
  }
  String fullClientId = clientId;
  fullClientId += String(ESP.getEfuseMac(), HEX);

  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");

    // Attempt to connect with a keepalive interval of 60 seconds
    if (client.connect(fullClientId.c_str(), mqttUser, mqttPassword)) {
      Serial.println("connected");
      client.subscribe(fanControlTopic);
      client.subscribe(fanManualTopic);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 1 second");
      delay(1000);
    }
  }
}

void setup() {
  Wire.begin();
  Serial.begin(115200);
  pinMode(RELAY_PIN, OUTPUT);
  pinMode(PIR_SENSOR_PIN_1, INPUT);
  pinMode(PIR_SENSOR_PIN_2, INPUT);
  doorServo.attach(SERVO_PIN);

  setup_wifi();
  client.setServer(mqttServer, mqttPort);
  client.setCallback(callback);

  gasSensor.setRegressionMethod(1);
  gasSensor.setA(574.25);
  gasSensor.setB(-2.222);
  gasSensor.init();

  Serial.println("Calibrating MQ-2 Sensor, please wait...");
  float calcR0 = gasSensor.calibrate(9.83);
  if (isnan(calcR0)) {
    Serial.println("MQ-2 Sensor calibration failed!");
    while (1);
  }
  Serial.print("Calibration done! R0 = ");
  Serial.println(calcR0);
  gasSensor.setR0(calcR0);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  // Read PIR sensors and control door servo
  bool motionDetected1 = digitalRead(PIR_SENSOR_PIN_1);
  bool motionDetected2 = digitalRead(PIR_SENSOR_PIN_2);

  Serial.print("PIR Sensor 1 value: ");
  Serial.println(motionDetected1);
  Serial.print("PIR Sensor 2 value: ");
  Serial.println(motionDetected2);

  if (motionDetected1 || motionDetected2) {
    Serial.println("Motion detected");
    if (!doorOpen) {
      Serial.println("Opening door...");
      doorServo.write(90);
      delay(1000);
      doorOpen = true;
      Serial.println("Door opened");
      client.publish(doorStatusTopic, "open", true);
      doorOpenTime = millis();
    } else {
      doorOpenTime = millis();
    }
    delay(8000);
  }

  // Close the door if it has been open for too long
  if (doorOpen && millis()) {
    Serial.println("Closing door...");
    doorServo.write(0);
    delay(1000);
    doorOpen = false;
    Serial.println("Door closed");
    client.publish(doorStatusTopic, "closed", true);
  }

  // Read MQ-2 sensor values
  int rawValue = analogRead(MQ2_PIN);
  float voltage = (rawValue / 4095.0) * 3.3;

  // Calculate gas concentrations
  float gasConcentrationCO = voltage / 0.05;
  float gasConcentrationSmoke = voltage / 0.1;

  // Publish MQTT topics with QoS 1
  client.publish(coTopic, String(gasConcentrationCO).c_str(), true);
  client.publish(smokeTopic, String(gasConcentrationSmoke).c_str(), true);

  Serial.print("CO Concentration: ");
  Serial.print(gasConcentrationCO);
  Serial.println(" ppm");

  Serial.print("Smoke Concentration: ");
  Serial.print(gasConcentrationSmoke);
  Serial.println(" ppm");

  // Fan control logic based on mode
  if (manualFanControl) {
    if (manualFanOn) {
      digitalWrite(RELAY_PIN, HIGH);
      client.publish(fanStatusTopic, "working", true);
      Serial.println("Fan turned on manually.");
      delay(500);
    } else {
      digitalWrite(RELAY_PIN, LOW);
      client.publish(fanStatusTopic, "not working", true);
      Serial.println("Fan turned off manually.");
      delay(500);
    }
  } else if (automaticFanControl) {
    if (gasConcentrationCO > 35 || gasConcentrationSmoke > 10) {
      digitalWrite(RELAY_PIN, HIGH);
      client.publish(fanStatusTopic, "working", true);
      Serial.println("Turning on fan due to poor air quality.");
      delay(500);
    } else {
      digitalWrite(RELAY_PIN, LOW);
      client.publish(fanStatusTopic, "not working", true);
      Serial.println("Air quality is good.");
      delay(500);
    }
  }

  delay(6000);
}
