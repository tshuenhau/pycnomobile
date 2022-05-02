import 'package:flutter/material.dart';
// import 'package:pycnomobile/model/sensors/MasterSoilSensor.dart';
// import 'package:pycnomobile/model/sensors/NodeSoilSensor.dart';
import 'package:pycnomobile/model/sensors/Pulse.dart';
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

enum TYPE_OF_SENSOR {
  SONIC_ANEMOMETER,
  RAIN_GAUGE,
  MASTER_SOIL_SENSOR,
  NODE_SOIL_SENSOR,
  PULSE
}

enum IS_ACTIVE { ACTIVE, SEMI, INACTIVE }

abstract class Sensor {
  // TYPE_OF_SENSOR type;
  List<dynamic>? sli;
  String uid;
  String? name;
  String? img;
  String? address;
  int? epoch;
  String? site;
  bool? isLive;
  int? isLiveHealth;
  DateTime? isLiveTS;
  DateTime? updatedAt;
  DateTime? polledAt;
  String? soilType;
  String? readableAgo;
  String? readableAgoFull;
  List<Functionality>? functionalities;
  bool isSimActive;
  Sensor(
      {
      // required this.type,
      required this.uid,
      required this.name,
      required this.img,
      required this.address,
      required this.epoch,
      required this.site,
      required this.isLive,
      required this.isLiveTS,
      required this.isLiveHealth,
      required this.updatedAt,
      required this.polledAt,
      required this.soilType,
      required this.readableAgo,
      required this.readableAgoFull,
      required this.functionalities,
      required this.sli,
      required this.isSimActive});

  // Sonic Anemometer: K80xxxxx
  // Rain Gauge: K40xxxxx
  // Master Soil Sensor: Mxxx
  // Node Soil Sensor: Kxxx
  // Pulse: Pxxx
  //
  // static TYPE_OF_SENSOR getTypeOfSensor(String uid) {
  //   if (SonicAnemometer.isSonicAnemometer(uid)) {
  //     return TYPE_OF_SENSOR.SONIC_ANEMOMETER;
  //   } else if (RainGauge.isRainGauge(uid)) {
  //     return TYPE_OF_SENSOR.RAIN_GAUGE;
  //   } else if (MasterSoilSensor.isMasterSoilSensor(uid)) {
  //     return TYPE_OF_SENSOR.MASTER_SOIL_SENSOR;
  //   } else if (NodeSoilSensor.isNodeSoilSensor(uid)) {
  //     return TYPE_OF_SENSOR.NODE_SOIL_SENSOR;
  //   } else if (Pulse.isPulse(uid)) {
  //     return TYPE_OF_SENSOR.PULSE;
  //   } else {
  //     // throw Exception("Invalid sensor");
  //     return TYPE_OF_SENSOR.NODE_SOIL_SENSOR; //temporary
  //   }
  // }

  // bool isActive() {
  //   // print("start: " + DateTime.fromMillisecondsSinceEpoch(epoch!).toString());
  //   // print(DateTime.now());
  //   if (DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(epoch!))) {
  //     return true;
  //   }
  //   if (DateTimeRange(
  //               start: DateTime.fromMillisecondsSinceEpoch(epoch!),
  //               end: DateTime.now())
  //           .duration
  //           .inHours <=
  //       24) {
  //     return true;
  //   }
  //   return false;
  // }

  IS_ACTIVE isActive() {
    if (DateTime.now()
        .toUtc()
        .subtract(new Duration(hours: 8))
        .isBefore(polledAt!.toUtc())) {
      return IS_ACTIVE.ACTIVE;
    } else if (DateTime.now()
            .toUtc()
            .subtract(new Duration(hours: 8))
            .isAfter(polledAt!.toUtc()) &&
        DateTime.now()
            .toUtc()
            .subtract(new Duration(days: 15))
            .isBefore(polledAt!.toUtc())) {
      return IS_ACTIVE.SEMI;
    } else {
      return IS_ACTIVE.INACTIVE;
    }
  }

  static bool getIsSimActive(json) {
    if (json["sim1_lifeCycleStatus"] == "X") {
      return false;
    } else if (json["sim1_requestedTariff"] is String &&
        json["sim1_requestedTariff"].substring(0, 1) == "X") {
      return false;
    } else {
      return true;
    }
  }

  static getFunctionalities(Map<String, dynamic> json, TYPE_OF_SENSOR type) {
    List<Functionality> functionalities = List.empty(growable: true);
    // List<Functionality> soilMoisture = List.empty(growable: true);
    // List<Functionality> soilTemp = List.empty(growable: true);
    for (var i = 0; i < json["plottable"].length; i++) {
      // if (json["plottable"][i] == "TEMP") {
      //   functionalities.add(new Temp(json["TEMP"]?.toDouble()));
      // } else if (json["plottable"][i] == "HUM") {
      //   functionalities.add(new Hum(json["HUM"]?.toDouble()));
      // } else if (json["plottable"][i] == "BAT") {
      //   functionalities.add(new Bat(json["BAT"]?.toDouble()));
      // } else if (json["plottable"][i] == "RAINH") {
      //   functionalities.add(new Rainh(json["RAINH"]?.toDouble()));
      // } else if (json["plottable"][i] == "RAIN") {
      //   functionalities.add(new Rain(json["RAINH"]?.toDouble()));
      // } else if (json["plottable"][i] == "LW1") {
      //   functionalities.add(new Lw1(json["LW1"]?.toDouble()));
      // } else if (json["plottable"][i] == "LX1") {
      //   functionalities.add(new Lx1(json["LX1"]?.toDouble()));
      // } else if (json["plottable"][i] == "RSSI") {
      //   functionalities.add(new Rssi(json["RSSI"]?.toDouble()));
      // } else if (json["plottable"][i] == "UV") {
      //   functionalities.add(new Uv(json["UV"]?.toDouble()));
      // } else if (json["plottable"][i] == "WND") {
      //   functionalities.add(new Wnd(json["WND"]?.toDouble()));
      // } else if (json["plottable"][i] == "WNDR") {
      //   functionalities.add(new Wndr(json["WNDR"]?.toDouble()));
      // } else if (json["plottable"][i] == "ST1") {
      //   functionalities.add(new St1(json["ST1"]?.toDouble()));
      // } else if (json["plottable"][i] == "ST3") {
      //   functionalities.add(new St3(json["ST3"]?.toDouble()));
      // } else if (json["plottable"][i] == "ST5") {
      //   functionalities.add(new St5(json["ST5"]?.toDouble()));
      // } else if (json["plottable"][i] == "S1T") {
      //   functionalities.add(new S1t(json["S1T"]?.toDouble()));
      // } else if (json["plottable"][i] == "S2T") {
      //   functionalities.add(new S2t(json["S2T"]?.toDouble()));
      // } else if (json["plottable"][i] == "S3T") {
      //   functionalities.add(new S3t(json["S3T"]?.toDouble()));
      // } else if (json["plottable"][i] == "S4T") {
      //   functionalities.add(new S4t(json["S4T"]?.toDouble()));
      // } else if (json["plottable"][i] == "S5T") {
      //   functionalities.add(new S5t(json["S5T"]?.toDouble()));
      // } else if (json["plottable"][i] == "S6T") {
      //   functionalities.add(new S6t(json["S6T"]?.toDouble()));
      // } else {
      functionalities.add(new Functionality(
          value: json[json["plottable"][i]],
          unit: "",
          name: json["plottable"][i],
          color: Colors.black,
          icon: null,
          key: json["plottable"][i]));
      // }
    }
    // if (type == TYPE_OF_SENSOR.MASTER_SOIL_SENSOR ||
    //     type == TYPE_OF_SENSOR.NODE_SOIL_SENSOR) {
    //   functionalities.add(new S123456t(soilTemp));
    //   functionalities.add(new St135(soilMoisture));
    // }

    return functionalities;
  }

  // static getFunctionalities(Map<String, dynamic> json, TYPE_OF_SENSOR type) {
  //   List<Functionality> functionalities = List.empty(growable: true);
  //   List<Functionality> soilMoisture = List.empty(growable: true);
  //   List<Functionality> soilTemp = List.empty(growable: true);
  //   for (var i = 0; i < json["plottable"].length; i++) {
  //     if (json["plottable"][i] == "TEMP") {
  //       functionalities.add(new Temp(json["TEMP"]?.toDouble()));
  //     } else if (json["plottable"][i] == "HUM") {
  //       functionalities.add(new Hum(json["HUM"]?.toDouble()));
  //     } else if (json["plottable"][i] == "BAT") {
  //       functionalities.add(new Bat(json["BAT"]?.toDouble()));
  //     } else if (json["plottable"][i] == "RAINH") {
  //       functionalities.add(new Rainh(json["RAINH"]?.toDouble()));
  //     } else if (json["plottable"][i] == "RAIN") {
  //       functionalities.add(new Rain(json["RAINH"]?.toDouble()));
  //     } else if (json["plottable"][i] == "LW1") {
  //       functionalities.add(new Lw1(json["LW1"]?.toDouble()));
  //     } else if (json["plottable"][i] == "LX1") {
  //       functionalities.add(new Lx1(json["LX1"]?.toDouble()));
  //     } else if (json["plottable"][i] == "RSSI") {
  //       functionalities.add(new Rssi(json["RSSI"]?.toDouble()));
  //     } else if (json["plottable"][i] == "UV") {
  //       functionalities.add(new Uv(json["UV"]?.toDouble()));
  //     } else if (json["plottable"][i] == "WND") {
  //       functionalities.add(new Wnd(json["WND"]?.toDouble()));
  //     } else if (json["plottable"][i] == "WNDR") {
  //       functionalities.add(new Wndr(json["WNDR"]?.toDouble()));
  //     } else if (json["plottable"][i] == "ST1") {
  //       soilMoisture.add(new St1(json["ST1"]?.toDouble()));
  //     } else if (json["plottable"][i] == "ST3") {
  //       soilMoisture.add(new St3(json["ST3"]?.toDouble()));
  //     } else if (json["plottable"][i] == "ST5") {
  //       soilMoisture.add(new St5(json["ST5"]?.toDouble()));
  //     } else if (json["plottable"][i] == "S1T") {
  //       soilTemp.add(new S1t(json["S1T"]?.toDouble()));
  //     } else if (json["plottable"][i] == "S2T") {
  //       soilTemp.add(new S2t(json["S2T"]?.toDouble()));
  //     } else if (json["plottable"][i] == "S3T") {
  //       soilTemp.add(new S3t(json["S3T"]?.toDouble()));
  //     } else if (json["plottable"][i] == "S4T") {
  //       soilTemp.add(new S4t(json["S4T"]?.toDouble()));
  //     } else if (json["plottable"][i] == "S5T") {
  //       soilTemp.add(new S5t(json["S5T"]?.toDouble()));
  //     } else if (json["plottable"][i] == "S6T") {
  //       soilTemp.add(new S6t(json["S6T"]?.toDouble()));
  //     }
  //   }
  //   if (type == TYPE_OF_SENSOR.MASTER_SOIL_SENSOR ||
  //       type == TYPE_OF_SENSOR.NODE_SOIL_SENSOR) {
  //     functionalities.add(new S123456t(soilTemp));
  //     functionalities.add(new St135(soilMoisture));
  //   }

  //   return functionalities;
  // }

  bool isPulse() {
    return this.sli != null;
  }

  String toString() {
    // return "UID: $uid, Name: $name, Img: $img, Address: $address, Epoch: $epoch, Site: $site, IsLive?: $isLive, IsLiveHealth: $isLiveHealth, IsLiveTS: $isLiveTS, UpdatedAt: $updatedAt, PolledAt: $polledAt, SoilType: $soilType, ReadableAgo: $readableAgo, ReadableAgoFull: $readableAgoFull";
    return "name: $name, polledAt: $polledAt";
  }
}
