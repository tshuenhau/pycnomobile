import 'sensor.dart';

/**
 * The parent class of Master Soil Sensor and Node Soil Sensor
 */
class SoilSensor extends Sensor {
  double temp;
  double hum;
  double lw1;
  String txt;
  double rainh;
  int lfreq;
  double ve;
  double bat;
  double rssi;
  double ns;
  double s1t;
  double s2t;
  double s3t;
  double s4t;
  double s5t;
  double s6t;
  double st1;
  double st3;
  double st5;

  void setLatestInfo(List<Map<String, dynamic>> result) {
    Map<String, dynamic> response = result[0];
    this.temp = response["TEMP"];
    this.hum = response["HUM"];
    this.lw1 = response["LW1"];
    this.txt = response["TXT"];
    this.rainh = response["RAINH"];
    this.lfreq = response["LFREQ"];
    this.ve = response["VE"];
    this.bat = response["BAT"];
    this.rssi = response["RSSI"];
    this.ns = response["NS"];
    this.s1t = response["S1T"];
    this.s2t = response["S2T"];
    this.s3t = response["S3T"];
    this.s4t = response["S4T"];
    this.s5t = response["S5T"];
    this.s6t = response["S6T"];
    this.st1 = response["ST1"];
    this.st3 = response["ST3"];
    this.st5 = response["ST5"];
  }

  SoilSensor(
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
      this.lw1,
      this.txt,
      this.rainh,
      this.lfreq,
      this.ve,
      this.bat,
      this.rssi,
      this.ns,
      this.s1t,
      this.s2t,
      this.s3t,
      this.s4t,
      this.s5t,
      this.s6t,
      this.st1,
      this.st3,
      this.st5)
      : super(
            uid,
            name,
            img,
            address,
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
}
