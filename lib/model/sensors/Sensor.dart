import 'package:flutter/material.dart';
// import 'package:pycnomobile/model/sensors/MasterSoilSensor.dart';
// import 'package:pycnomobile/model/sensors/NodeSoilSensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

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

  IS_ACTIVE isActive() {
    if (DateTime.now()
        .toUtc()
        .subtract(new Duration(hours: 8))
        .isBefore(polledAt!.toUtc())) {
      // polled < 8 hours
      return IS_ACTIVE.ACTIVE;
    } else if (DateTime.now()
            .toUtc()
            .subtract(new Duration(hours: 8))
            .isAfter(polledAt!.toUtc()) &&
        DateTime.now()
            .toUtc()
            .subtract(new Duration(days: 15))
            .isBefore(polledAt!.toUtc())) {
      // 8 hours < polled < 15 days
      return IS_ACTIVE.SEMI;
    } else {
      // polled > 15 days
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

    for (var i = 0; i < json["plottable"].length; i++) {
      functionalities.add(new Functionality(
          value: json[json["plottable"][i]],
          unit: "",
          name: json["plottable"][i],
          color: Colors.black,
          icon: null,
          key: json["plottable"][i]));
    }

    return functionalities;
  }

  bool isPulse() {
    return this.sli != null;
  }

  Sensor clone();

  String toString() {
    // return "UID: $uid, Name: $name, Img: $img, Address: $address, Epoch: $epoch, Site: $site, IsLive?: $isLive, IsLiveHealth: $isLiveHealth, IsLiveTS: $isLiveTS, UpdatedAt: $updatedAt, PolledAt: $polledAt, SoilType: $soilType, ReadableAgo: $readableAgo, ReadableAgoFull: $readableAgoFull";
    return "name: $name, polledAt: $polledAt";
  }
}
