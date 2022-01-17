import 'sensor.dart';
import 'soilsensor.dart';

class NodeSoilSensor extends SoilSensor {
  static String SENSOR_TYPE = "master soil sensor";

  double pw;

  NodeSoilSensor(
      String uid,
      String name,
      String address,
      String img,
      int epoch,
      String site,
      bool isLive,
      int isLiveHealth,
      DateTime isLiveTS,
      DateTime updatedAt,
      DateTime polledAt,
      String soilType,
      String readableAgo,
      String readableAgoFull,
      double temp,
      double hum,
      double lw1,
      String txt,
      double rainh,
      int lfreq,
      double ve,
      double bat,
      double rssi,
      double ns,
      this.pw)
      : super(
            uid,
            name,
            address,
            img,
            epoch,
            site,
            isLive,
            isLiveHealth,
            isLiveTS,
            updatedAt,
            polledAt,
            soilType,
            readableAgo,
            readableAgoFull,
            temp,
            hum,
            lw1,
            txt,
            rainh,
            lfreq,
            ve,
            bat,
            rssi,
            ns);

  static bool isNodeSoilSensor(String uid) {
    return uid.startsWith("K") &&
        !uid.startsWith("K40") &&
        !uid.startsWith("K80");
  }
}
