import 'SoilSensor.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/functionalities/Bat.dart';
import 'package:pycnomobile/model/functionalities/Rssi.dart';
import 'package:pycnomobile/model/functionalities/Temp.dart';
import 'package:pycnomobile/model/functionalities/Hum.dart';
import 'package:pycnomobile/model/functionalities/Lw1.dart';
import 'package:pycnomobile/model/functionalities/Lx1.dart';
import 'package:pycnomobile/model/functionalities/Rainh.dart';
import 'package:pycnomobile/model/functionalities/S123456t.dart';
import 'package:pycnomobile/model/functionalities/S1t.dart';
import 'package:pycnomobile/model/functionalities/S2t.dart';
import 'package:pycnomobile/model/functionalities/S3t.dart';
import 'package:pycnomobile/model/functionalities/S4t.dart';
import 'package:pycnomobile/model/functionalities/S5t.dart';
import 'package:pycnomobile/model/functionalities/S6t.dart';
import 'package:pycnomobile/model/functionalities/St135.dart';
import 'package:pycnomobile/model/functionalities/St1.dart';
import 'package:pycnomobile/model/functionalities/St3.dart';
import 'package:pycnomobile/model/functionalities/St5.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

class MasterSoilSensor extends SoilSensor {
  double? mdm;
  int? gr;
  int? grf;
  int? cme;
  String? iccid;
  String? net;
  String? ip;

  MasterSoilSensor(
      {required String uid,
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
      required String? txt,
      required int lfreq,
      required double ve,
      required double? ns,
      required this.mdm,
      required this.gr,
      required this.grf,
      required this.cme,
      required this.iccid,
      required this.net,
      required this.ip,
      required List<Functionality> functionalities})
      : super(
            type: TYPE_OF_SENSOR.MASTER_SOIL_SENSOR,
            uid: uid,
            name: name,
            address: address,
            img: img,
            epoch: epoch,
            site: site,
            isLive: isLive,
            isLiveHealth: isLiveHealth,
            isLiveTS: isLiveTS,
            updatedAt: updatedAt,
            polledAt: polledAt,
            soilType: soilType,
            readableAgo: readableAgo,
            readableAgoFull: readableAgoFull,
            txt: txt,
            lfreq: lfreq,
            ve: ve,
            ns: ns,
            functionalities: functionalities);

  static bool isMasterSoilSensor(String uid) {
    return uid.startsWith("M");
  }

  factory MasterSoilSensor.fromJson(Map<String, dynamic> json) {
    return MasterSoilSensor(
      uid: json["UID"],
      name: json["name"],
      address: json["address"],
      img: json["img"],
      epoch: json["epoch"],
      site: json["site"],
      isLive: json["isLive"] == "YES",
      isLiveHealth: json["isLiveHealth"],
      isLiveTS: DateTime.parse(json["isLiveTS"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      polledAt: DateTime.parse(json["polledAt"]),
      soilType: json["soilType"],
      readableAgo: json["readableAgo"],
      readableAgoFull: json["readableAgoFull"],
      txt: json["TXT"],
      lfreq: json["LFREQ"],
      ve: json["VE"].toDouble(),
      ns: json["NS"]?.toDouble(),
      gr: json["GR"],
      mdm: json["MDM"]?.toDouble(),
      grf: json["GRF"],
      cme: json["CME"],
      iccid: json["ICCID"],
      net: json["NET"],
      ip: json["IP"],
      functionalities: [
        new Temp(json["TEMP"]),
        new Hum(json["HUM"].toDouble()),
        new Bat(json["BAT"].toDouble()),
        new Rainh(json["RAINH"].toDouble()),
        new Lw1(json["LW1"].toDouble()),
        new Lx1(json["LX1"].toDouble()),
        new Rssi(json["RSSI"].toDouble()),
        new S123456t([
          new S1t(json["S1T"]?.toDouble()),
          new S2t(json["S2T"]?.toDouble()),
          new S3t(json["S3T"]?.toDouble()),
          new S4t(json["S4T"]?.toDouble()),
          new S5t(json["S5T"]?.toDouble()),
          new S6t(json["S6T"]?.toDouble()),
        ]),
        new St135([
          new St1(json["ST1"]?.toDouble()),
          new St3(json["ST3"]?.toDouble()),
          new St5(json["ST5"]?.toDouble())
        ]),
      ],
    );
  }

  @override
  String toString() {
    return "Master Soil Sensor: " +
        super.toString() +
        ", MDM: $mdm, GR: $gr, GRF: $grf, CME: $cme, ICCID: $iccid, NET: $net, IP: $ip";
  }
}
