import 'sensor.dart';

class RainGauge extends Sensor {
  static String SENSOR_TYPE = "rain gauge";

  double temp;
  double hum;
  double rain;
  double bat;
  double rssi;
  double pw;

  RainGauge(
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
      this.temp,
      this.hum,
      this.rain,
      this.bat,
      this.rssi,
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
            readableAgoFull);

  static bool isRainGauge(String uid) {
    return uid.startsWith("K40");
  }
}
