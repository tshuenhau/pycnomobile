import 'Sensor.dart';

/**
 * The parent class of Master Soil Sensor and Node Soil Sensor
 */
abstract class SoilSensor extends Sensor {
  double temp;
  double hum;
  double lw1;
  String? txt;
  double rainh;
  int lfreq;
  double ve;
  double bat;
  double rssi;
  double? ns;
  double? s1t;
  double? s2t;
  double? s3t;
  double? s4t;
  double? s5t;
  double? s6t;
  double? st1;
  double? st3;
  double? st5;

  SoilSensor(
      {required TYPE_OF_SENSOR type,
      required String uid,
      required String name,
      required String? address,
      required String? img,
      required int epoch,
      required String site,
      required bool isLive,
      required int isLiveHealth,
      required DateTime isLiveTS,
      required DateTime updatedAt,
      required DateTime polledAt,
      required String? soilType,
      required String readableAgo,
      required String readableAgoFull,
      required this.temp,
      required this.hum,
      required this.lw1,
      required this.txt,
      required this.rainh,
      required this.lfreq,
      required this.ve,
      required this.bat,
      required this.rssi,
      required this.ns,
      required this.s1t,
      required this.s2t,
      required this.s3t,
      required this.s4t,
      required this.s5t,
      required this.s6t,
      required this.st1,
      required this.st3,
      required this.st5})
      : super(
            type,
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

  // This method may not be needed
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

  @override
  String toString() {
    return super.toString() +
        ", TEMP: $temp, HUM: $hum, LW1: $lw1, TXT: $txt, RAINH: $rainh, LFREQ: $lfreq, VE: $ve, BAT: $bat, RSSI: $rssi, NS: $ns, S1T: $s1t, S2T: $s2t, S3T: $s3t, S4T: $s4t, S5T: $s5t, S6T: $s6t, ST1: $st1, ST3: $st3, ST5: $st5";
  }
}
