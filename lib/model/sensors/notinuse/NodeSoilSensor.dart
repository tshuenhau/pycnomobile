// import 'package:Sensr/model/sensors/Sensor.dart';
// import 'package:Sensr/model/functionalities/Bat.dart';
// import 'package:Sensr/model/functionalities/Hum.dart';
// import 'package:Sensr/model/functionalities/Lw1.dart';
// import 'package:Sensr/model/functionalities/Lx1.dart';
// import 'package:Sensr/model/functionalities/Rainh.dart';
// import 'package:Sensr/model/functionalities/Rssi.dart';
// import 'package:Sensr/model/functionalities/S123456t.dart';
// import 'package:Sensr/model/functionalities/S1t.dart';
// import 'package:Sensr/model/functionalities/S2t.dart';
// import 'package:Sensr/model/functionalities/S3t.dart';
// import 'package:Sensr/model/functionalities/S4t.dart';
// import 'package:Sensr/model/functionalities/S5t.dart';
// import 'package:Sensr/model/functionalities/S6t.dart';
// import 'package:Sensr/model/functionalities/St135.dart';
// import 'package:Sensr/model/functionalities/St1.dart';
// import 'package:Sensr/model/functionalities/St3.dart';
// import 'package:Sensr/model/functionalities/St5.dart';
// import 'package:Sensr/model/functionalities/Temp.dart';
// import 'package:Sensr/model/functionalities/Functionality.dart';
// import 'SoilSensor.dart';

// class NodeSoilSensor extends SoilSensor {
//   double? pw;

//   NodeSoilSensor(
//       {required String uid,
//       required String? name,
//       required String? address,
//       required String? img,
//       required int? epoch,
//       required String? site,
//       required bool? isLive,
//       required int? isLiveHealth,
//       required DateTime? isLiveTS,
//       required DateTime? updatedAt,
//       required DateTime? polledAt,
//       required String? soilType,
//       required String? readableAgo,
//       required String? readableAgoFull,
//       required String? txt,
//       required int? lfreq,
//       required double? ve,
//       required double? ns,
//       required this.pw,
//       required List<Functionality> functionalities})
//       : super(
//             type: TYPE_OF_SENSOR.NODE_SOIL_SENSOR,
//             uid: uid,
//             name: name,
//             address: address,
//             img: img,
//             epoch: epoch,
//             site: site,
//             isLive: isLive,
//             isLiveHealth: isLiveHealth,
//             isLiveTS: isLiveTS,
//             updatedAt: updatedAt,
//             polledAt: polledAt,
//             soilType: soilType,
//             readableAgo: readableAgo,
//             readableAgoFull: readableAgoFull,
//             txt: txt,
//             lfreq: lfreq,
//             ve: ve,
//             ns: ns,
//             functionalities: functionalities);

//   static bool isNodeSoilSensor(String uid) {
//     return uid.startsWith("K") &&
//         !uid.startsWith("K40") &&
//         !uid.startsWith("K80");
//   }

//   factory NodeSoilSensor.fromJson(Map<String, dynamic> json) => NodeSoilSensor(
//       uid: json["UID"],
//       name: json["name"],
//       address: json["address"],
//       img: json["img"],
//       epoch: json["epoch"],
//       site: json["site"],
//       isLive: json["isLive"] == "YES",
//       isLiveHealth: json["isLiveHealth"],
//       isLiveTS: DateTime.parse(json["isLiveTS"]),
//       updatedAt: DateTime.parse(json["updatedAt"]),
//       polledAt: DateTime.parse(json["polledAt"]),
//       soilType: json["soilType"],
//       readableAgo: json["readableAgo"],
//       readableAgoFull: json["readableAgoFull"],
//       txt: json["TXT"],
//       lfreq: json["LFREQ"],
//       ve: json["VE"],
//       ns: json["NS"]?.toDouble(),
//       pw: json["PW"]?.toDouble(),
//       functionalities:
//           Sensor.getFunctionalities(json, TYPE_OF_SENSOR.NODE_SOIL_SENSOR));

//   @override
//   String toString() {
//     return "Node Soil Sensor: " + super.toString() + ", PW: $pw";
//   }

//   // getFunctionalities(Map<String, dynamic> json) {
//   //   List<Functionality> functionalities = List.empty(growable: true);
//   //   for (var i = 0; i < json["plottable"].length; i++) {
//   //     if (json["plottable"][i] == "TEMP") {
//   //       functionalities.add(new Temp(json["TEMP"]?.toDouble()));
//   //     } else if (json["plottable"][i] == "HUM") {
//   //       functionalities.add(new Hum(json["HUM"]?.toDouble()));
//   //     } else if (json["plottable"][i] == "BAT") {
//   //       functionalities.add(new Bat(json["BAT"]?.toDouble()));
//   //     } else if (json["plottable"][i] == "RAINH") {
//   //       functionalities.add(new Rainh(json["RAINH"]?.toDouble()));
//   //     } else if (json["plottable"][i] == "LW1") {
//   //       functionalities.add(new Lw1(json["LW1"]?.toDouble()));
//   //     } else if (json["plottable"][i] == "LX1") {
//   //       functionalities.add(new Lx1(json["LX1"]?.toDouble()));
//   //     } else if (json["plottable"][i] == "RSSI") {
//   //       functionalities.add(new Rssi(json["RSSI"]?.toDouble()));
//   //     }
//   //   }
//   // }
// }
