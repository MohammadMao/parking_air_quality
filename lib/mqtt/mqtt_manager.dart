// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'mqtt_state.dart';
import '../models.dart';

class MqttManager {
  final MQTTAppState _currentState;
  MqttServerClient? _client;

  // MQTT topic names
  final String _coTopic = 'co/level';
  final String _smokeTopic = 'smoke/level';
  final String _fanTopic = 'fan/status';
  final String _doorTopic = 'door/status';
  final String _fanmodeTopic = 'control/fan';
  // final String _manualFanTopic = 'control/fan/manual';

  // server info
  final String host = 'broker.hivemq.com';
  final String clientId = 'MqttDashboard-9925752';
  final String username = 'IOT_Park';
  final String password = 'Parkin1234';

  // client get
  MqttServerClient? get client => _client;

  // Inputs provider = Inputs();
  late Inputs _provider;

  MqttManager({required MQTTAppState state}) : _currentState = state;

  void initializeMQTTClient(BuildContext context) {
    // _client = MqttServerClient(host, _identifier);
    _client = MqttServerClient.withPort(host, clientId, 1883);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 10;
    _client!.onDisconnected = onDisconnected;
    _client!.logging(on: false);
    // _client!.secure = false; // for secure connection

    // Add the successful connection callback
    _client!.onConnected = () => onConnected(context);
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
      ..authenticateAs(username, password)
          .withWillTopic('lastwills')
          .withWillMessage('Will message')
          .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE: client connecting....');
    _client!.connectionMessage = connMess;
  }

  // connect function
  void connect() async {
    assert(_client != null);
    try {
      print('## start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client!.connect();
    } on Exception catch (e) {
      print('## client exception - $e');
      disconnect();
    }
  }

  // disconnect function
  void disconnect() {
    print('Disconnected');
    _client!.disconnect();
  }

  // publish function
  void publish(String message, String topic) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  /// The successful connect callback
  void onConnected(BuildContext context) async {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print('## client connected....');
    _provider = Provider.of<Inputs>(context, listen: false);

    // Subscribe to all topics
    _client!.subscribe(_coTopic, MqttQos.atLeastOnce);
    _client!.subscribe(_smokeTopic, MqttQos.atLeastOnce);
    _client!.subscribe(_doorTopic, MqttQos.atLeastOnce);
    _client!.subscribe(_fanTopic, MqttQos.atLeastOnce);
    _client!.subscribe(_fanmodeTopic, MqttQos.atLeastOnce);

    // Listen to updates from the client
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage payload = c![0].payload as MqttPublishMessage;
      final String message =
          MqttPublishPayload.bytesToStringAsString(payload.payload.message);
      final String topic = c[0].topic;

      // Send input message to provider based on the topic
      if (topic == _coTopic) {
        _provider.updateCo(message);
      } else if (topic == _smokeTopic) {
        _provider.updateSmoke(message);
      } else if (topic == _doorTopic) {
        _provider.updateDoor(message);
      } else if (topic == _fanTopic) {
        _provider.updateFan(message);
      } else if (topic == _fanmodeTopic) {
        _provider.updateMode(message);
      }

      print('topic is <$topic>, payload is <-- $message -->');
      print('');
    });

    print('## OnConnected client callback - Client connection was successful');

    // _client!.disconnect();
  }
}
