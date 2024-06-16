import 'package:flutter/cupertino.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class MQTTAppState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    // notifyListeners();
  }

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
}
