import 'Sensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

/**
 * The parent class of Master Soil Sensor and Node Soil Sensor
 */
abstract class SoilSensor extends Sensor {
  String? txt;
  int lfreq;
  double ve;
  double? ns;

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
      required this.txt,
      required this.lfreq,
      required this.ve,
      required this.ns,
      List<Functionality>? functionalities})
      : super(
            type: type,
            uid: uid,
            name: name,
            img: img,
            address: address,
            epoch: epoch,
            site: site,
            isLive: isLive,
            isLiveTS: isLiveTS,
            isLiveHealth: isLiveHealth,
            updatedAt: updatedAt,
            polledAt: polledAt,
            soilType: soilType,
            readableAgo: readableAgo,
            readableAgoFull: readableAgoFull,
            functionalities: functionalities);

  // This method may not be needed
  void setLatestInfo(List<Map<String, dynamic>> result) {
    Map<String, dynamic> response = result[0];
    // this.temp = response["TEMP"];
    // this.hum = response["HUM"];
    // this.lw1 = response["LW1"];
    // this.txt = response["TXT"];
    // this.rainh = response["RAINH"];
    // this.lfreq = response["LFREQ"];
    // this.ve = response["VE"];
    // this.bat = response["BAT"];
    // this.rssi = response["RSSI"];
    // this.ns = response["NS"];
    // this.s1t = response["S1T"];
    // this.s2t = response["S2T"];
    // this.s3t = response["S3T"];
    // this.s4t = response["S4T"];
    // this.s5t = response["S5T"];
    // this.s6t = response["S6T"];
    // this.st1 = response["ST1"];
    // this.st3 = response["ST3"];
    // this.st5 = response["ST5"];
  }

  @override
  String toString() {
    return super.toString();
  }
}
