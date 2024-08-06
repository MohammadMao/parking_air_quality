import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

// Provider Model
class Inputs extends ChangeNotifier {
  late String _co = '0.0';
  late String _door = 'closed';
  late String _smoke = '0.0';
  late String _fan = 'working';
  late String _mode = '0';

  double get coval => double.parse(_co);
  bool get doorval => _door == 'open';
  double get smokeval => double.parse(_smoke);
  bool get fanval => _fan != 'not working';
  bool get fanMode => _mode == '1';

  void updateCo(String co) async {
    _co = co;
    notifyListeners();
  }

  void updateDoor(String door) {
    _door = door;
    notifyListeners();
  }

  void updateSmoke(String smoke) {
    _smoke = smoke;
    notifyListeners();
  }

  void updateFan(String fan) {
    _fan = fan;
    notifyListeners();
  }

  void updateMode(String mode) {
    _mode = mode;
    notifyListeners();
  }
}
