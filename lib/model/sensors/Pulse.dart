import 'package:pycnomobile/model/sensors/Sensor.dart';

class Pulse {
  static bool isPulse(String uid) {
    return uid.startsWith("P");
  }
}
