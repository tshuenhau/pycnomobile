import 'sensor.dart';

class SonicAnemometer extends Sensor {
  static String SENSOR_TYPE = "sonic anemometer";

  double temp;
  double hum;
  double wnd;
  double gst;
  double wndr;
  double lx1;
  double uv;
  double bat;
  double rssi;
  double pw;

  SonicAnemometer(
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
      this.wnd,
      this.gst,
      this.wndr,
      this.lx1,
      this.uv,
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
            isLiveTS,
            isLiveHealth,
            updatedAt,
            polledAt,
            soilType,
            readableAgo,
            readableAgoFull);

  static bool isSonicAnemometer(String uid) {
    return uid.startsWith("K80");
  }
}
