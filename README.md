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

### Flutter App Configuration (Important)
Before running the Flutter app, you need to configure the MQTT connection settings:

1. **Copy the environment template:**
   ```bash
   cp .env.example .env
   ```

2. **Edit the `.env` file** with your MQTT broker details:
   ```
   MQTT_HOST=your_mqtt_broker_address
   MQTT_PORT=1883
   MQTT_CLIENT_ID=parking_air_quality_client
   MQTT_USERNAME=your_username
   MQTT_PASSWORD=your_password
   ```

   - **MQTT_HOST:** The address of your MQTT broker (e.g., `broker.example.com` or IP address)
   - **MQTT_PORT:** The port your MQTT broker is running on (default is 1883)
   - **MQTT_CLIENT_ID:** A unique identifier for this client
   - **MQTT_USERNAME:** Username for MQTT broker authentication
   - **MQTT_PASSWORD:** Password for MQTT broker authentication

3. **Run the Application:** Run the Flutter app on your device or emulator.
   ```bash
   flutter run
   ```

**Note:** The `.env` file is ignored by git and not included in version control for security reasons. Each developer or deployment must create their own `.env` file with appropriate credentials.

## Contributing
Contributions are welcome! Please feel free to open issues or submit pull requests.


## App Preview

<img width="1668" height="1280" alt="-2147483648_-211778" src="https://github.com/user-attachments/assets/106cd94f-9d26-437d-b16d-04011e28aba8" />

