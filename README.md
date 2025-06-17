# Parking Air Quality Monitoring System

This project monitors air quality and occupancy in a parking area, app users can monitor and modify the parking door, fan, and air quality status. Using a combination of Flutter for the user interface, an MQTT server for communication, an ESP32 microcontroller, and various sensors.

## Project Overview

The system consists of an ESP32 microcontroller connected to:

*   **MQ-135 Gas Sensor:** Measures air quality (CO and smoke levels).
*   **PIR Sensor(s):** Detects motion (occupancy).
*   **Relay:** Controls a fan for ventilation.
*   **Servo Motor:** Controls a door (optional).

The ESP32 publishes sensor data and control commands via an MQTT broker to a Flutter application. The Flutter app displays real-time sensor readings, allows manual control of the fan and door, and visualizes the air quality status.

## Technologies Used

*   **Frontend:** Flutter
*   **Backend:** ESP32 Microcontroller, Arduino IDE (C++)
*   **Communication:** MQTT (HiveMQ Broker used in example)
*   **Sensors:** MQ-135 Gas Sensor, PIR Sensor(s)

## System Architecture
The Flutter app subscribes to MQTT topics published by the ESP32 to receive sensor data and status updates.  It also publishes messages to control the fan and door.

## Arduino Code (ESP32)

The Arduino code manages the sensors, actuators, and MQTT communication.  Key features include:

*   **Sensor Reading:** Reads data from the MQ-135 and PIR sensors.
*   **MQTT Publishing:** Publishes sensor readings and status updates to MQTT topics.
*   **MQTT Subscribing:** Subscribes to control topics for manual fan control.
*   **Actuator Control:** Controls the relay (fan) and servo motor (door) based on sensor readings and user commands.
*   **Automatic/Manual Fan Control:** Allows switching between automatic (sensor-based) and manual fan control.

For Arduino Code (see attached file: arduino_code.cpp)

## Flutter Code (Highlights)
The Flutter code provides the user interface and handles MQTT communication. Key features include:

MQTT Client: Uses the mqtt_client package to connect to the MQTT broker.
Real-time Data Display: Displays sensor readings and status information.
User Interaction: Allows users to manually control the fan and door.
Air Quality Visualization: Provides visual cues indicating good or poor air quality.

## Setup and Installation
* **Install Arduino IDE:** Download and install the Arduino IDE from https://www.arduino.cc/.
* **Install Libraries:** Install the necessary Arduino libraries (PubSubClient, ESP32Servo, MQUnifiedsensor).
* **Configure WiFi and MQTT:** Update the Arduino code with your WiFi credentials and MQTT broker details.
* **Install Flutter:** Download and install Flutter from https://flutter.dev/.
* **Install Dependencies:** Run flutter pub get to install the Flutter dependencies.
* **Run the Application:** Run the Flutter app on your device or emulator.

## Contributing
Contributions are welcome! Please feel free to open issues or submit pull requests.

## App Preview
![previewimg1](./preview/PAQ(1).png) ![previewimg2](./preview/PAQ(2).png)
