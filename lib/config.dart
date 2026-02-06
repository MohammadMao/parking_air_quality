import 'package:flutter/services.dart';
import 'dart:developer' as developer;

class EnvConfig {
  static late String host;
  static late int port;
  static late String clientId;
  static late String username;
  static late String password;

  /// Load environment variables from .env file
  static Future<void> load() async {
    try {
      final String envContent = await rootBundle.loadString('.env');
      final Map<String, String> envVars = _parseEnv(envContent);

      host = envVars['MQTT_HOST'] ?? 'localhost';
      port = int.tryParse(envVars['MQTT_PORT'] ?? '1883') ?? 1883;
      clientId = envVars['MQTT_CLIENT_ID'] ?? 'flutter_client';
      username = envVars['MQTT_USERNAME'] ?? '';
      password = envVars['MQTT_PASSWORD'] ?? '';
    } catch (e) {
      // Fallback to defaults if .env file is not found
      host = 'localhost';
      port = 1883;
      clientId = 'flutter_client';
      username = '';
      password = '';
      developer.log('Warning: Could not load .env file. Using default values.');
    }
  }

  /// Parse .env file content into a map
  static Map<String, String> _parseEnv(String content) {
    final Map<String, String> envMap = {};
    final List<String> lines = content.split('\n');

    for (final String line in lines) {
      // Skip empty lines and comments
      if (line.isEmpty || line.startsWith('#')) {
        continue;
      }

      final int separatorIndex = line.indexOf('=');
      if (separatorIndex != -1) {
        final String key = line.substring(0, separatorIndex).trim();
        final String value = line.substring(separatorIndex + 1).trim();
        envMap[key] = value;
      }
    }

    return envMap;
  }
}
