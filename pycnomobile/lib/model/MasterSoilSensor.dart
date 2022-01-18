import 'sensor.dart';
import 'soilsensor.dart';

class MasterSoilSensor extends SoilSensor {
  static String SENSOR_TYPE = "master soil sensor";

  double mdm;
  int gr;
  int grf;
  int cme;
  int iccid;
  int net;
  String ip;

  MasterSoilSensor(
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
      double s1t,
      double s2t,
      double s3t,
      double s4t,
      double s5t,
      double s6t,
      double st1,
      double st3,
      double st5,
      this.mdm,
      this.gr,
      this.grf,
      this.cme,
      this.iccid,
      this.net,
      this.ip)
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
            ns,
            s1t,
            s2t,
            s3t,
            s4t,
            s5t,
            s6t,
            st1,
            st3,
            st5);

  static bool isMasterSoilSensor(String uid) {
    return uid.startsWith("M");
  }
}
