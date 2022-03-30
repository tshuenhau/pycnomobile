import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/model/functionalities/Bat.dart';
import 'package:pycnomobile/model/functionalities/Hum.dart';
import 'package:pycnomobile/model/functionalities/Lw1.dart';
import 'package:pycnomobile/model/functionalities/Lx1.dart';
import 'package:pycnomobile/model/functionalities/Rainh.dart';
import 'package:pycnomobile/model/functionalities/Rssi.dart';
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
import 'package:pycnomobile/model/functionalities/Temp.dart';
import 'package:pycnomobile/model/functionalities/Rain.dart';
import 'package:pycnomobile/model/functionalities/Uv.dart';
import 'package:pycnomobile/model/functionalities/Wnd.dart';
import 'package:pycnomobile/model/functionalities/Wndr.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';

class FixSensor extends Sensor {
  FixSensor({
    required uid,
    required name,
    required img,
    required address,
    required epoch,
    required site,
    required isLive,
    required isLiveTS,
    required isLiveHealth,
    required updatedAt,
    required polledAt,
    required soilType,
    required readableAgo,
    required readableAgoFull,
    required functionalities,
  }) : super(
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
            functionalities: functionalities);

  static getFunctionalities(Map<String, dynamic> json) {
    List<Functionality> functionalities = List.empty(growable: true);
    List<Functionality> soilMoisture = List.empty(growable: true);
    List<Functionality> soilTemp = List.empty(growable: true);
    for (var i = 0; i < json["plottable"].length; i++) {
      if (json["plottable"][i] == "TEMP") {
        functionalities.add(new Temp(json["TEMP"]?.toDouble()));
      } else if (json["plottable"][i] == "HUM") {
        functionalities.add(new Hum(json["HUM"]?.toDouble()));
      } else if (json["plottable"][i] == "BAT") {
        functionalities.add(new Bat(json["BAT"]?.toDouble()));
      } else if (json["plottable"][i] == "RAINH") {
        functionalities.add(new Rainh(json["RAINH"]?.toDouble()));
      } else if (json["plottable"][i] == "RAIN") {
        functionalities.add(new Rain(json["RAINH"]?.toDouble()));
      } else if (json["plottable"][i] == "LW1") {
        functionalities.add(new Lw1(json["LW1"]?.toDouble()));
      } else if (json["plottable"][i] == "LX1") {
        functionalities.add(new Lx1(json["LX1"]?.toDouble()));
      } else if (json["plottable"][i] == "RSSI") {
        functionalities.add(new Rssi(json["RSSI"]?.toDouble()));
      } else if (json["plottable"][i] == "UV") {
        functionalities.add(new Uv(json["UV"]?.toDouble()));
      } else if (json["plottable"][i] == "WND") {
        functionalities.add(new Wnd(json["WND"]?.toDouble()));
      } else if (json["plottable"][i] == "WNDR") {
        functionalities.add(new Wndr(json["WNDR"]?.toDouble()));
      } else if (json["plottable"][i] == "ST1") {
        soilMoisture.add(new St1(json["ST1"]?.toDouble()));
      } else if (json["plottable"][i] == "ST3") {
        soilMoisture.add(new St3(json["ST3"]?.toDouble()));
      } else if (json["plottable"][i] == "ST5") {
        soilMoisture.add(new St5(json["ST5"]?.toDouble()));
      } else if (json["plottable"][i] == "S1T") {
        soilTemp.add(new S1t(json["S1T"]?.toDouble()));
      } else if (json["plottable"][i] == "S2T") {
        soilTemp.add(new S2t(json["S2T"]?.toDouble()));
      } else if (json["plottable"][i] == "S3T") {
        soilTemp.add(new S3t(json["S3T"]?.toDouble()));
      } else if (json["plottable"][i] == "S4T") {
        soilTemp.add(new S4t(json["S4T"]?.toDouble()));
      } else if (json["plottable"][i] == "S5T") {
        soilTemp.add(new S5t(json["S5T"]?.toDouble()));
      } else if (json["plottable"][i] == "S6T") {
        soilTemp.add(new S6t(json["S6T"]?.toDouble()));
      }
    }
    if (soilTemp.length > 0 || soilMoisture.length > 0) {
      functionalities.add(new S123456t(soilTemp));
      functionalities.add(new St135(soilMoisture));
    }

    return functionalities;
  }

  factory FixSensor.fromJson(Map<String, dynamic> json) {
    return FixSensor(
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
        functionalities: getFunctionalities(json));
  }
}
