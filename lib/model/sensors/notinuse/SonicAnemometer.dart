// import 'package:Sensr/model/sensors/Sensor.dart';
// import 'package:Sensr/model/functionalities/Bat.dart';
// import 'package:Sensr/model/functionalities/Gst.dart';
// import 'package:Sensr/model/functionalities/Hum.dart';
// import 'package:Sensr/model/functionalities/Lx1.dart';
// import 'package:Sensr/model/functionalities/Rssi.dart';
// import 'package:Sensr/model/functionalities/Temp.dart';
// import 'package:Sensr/model/functionalities/Uv.dart';
// import 'package:Sensr/model/functionalities/Wnd.dart';
// import 'package:Sensr/model/functionalities/Wndr.dart';
// import 'package:Sensr/model/functionalities/Functionality.dart';

// class SonicAnemometer extends Sensor {
//   double? pw;

//   SonicAnemometer(
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
//       required List<Functionality>? functionalities,
//       required this.pw})
//       : super(
//             type: TYPE_OF_SENSOR.SONIC_ANEMOMETER,
//             uid: uid,
//             name: name,
//             address: address,
//             img: img,
//             epoch: epoch,
//             site: site,
//             isLive: isLive,
//             isLiveTS: isLiveTS,
//             isLiveHealth: isLiveHealth,
//             updatedAt: updatedAt,
//             polledAt: polledAt,
//             soilType: soilType,
//             readableAgo: readableAgo,
//             readableAgoFull: readableAgoFull,
//             functionalities: functionalities);

//   static bool isSonicAnemometer(String uid) {
//     return uid.startsWith("K80");
//   }

//   factory SonicAnemometer.fromJson(Map<String, dynamic> json) {
//     return SonicAnemometer(
//         uid: json["UID"],
//         name: json["name"],
//         address: json["address"],
//         img: json["img"],
//         epoch: json["epoch"],
//         site: json["site"],
//         isLive: json["isLive"] == "YES",
//         isLiveHealth: json["isLiveHealth"],
//         isLiveTS: DateTime.parse(json["isLiveTS"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         polledAt: DateTime.parse(json["polledAt"]),
//         soilType: json["soilType"],
//         readableAgo: json["readableAgo"],
//         readableAgoFull: json["readableAgoFull"],
//         pw: json["PW"]?.toDouble(),
//         functionalities:
//             Sensor.getFunctionalities(json, TYPE_OF_SENSOR.SONIC_ANEMOMETER));
//   }
// }
