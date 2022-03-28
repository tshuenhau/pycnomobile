// import 'package:pycnomobile/model/sensors/Sensor.dart';
// import 'package:pycnomobile/model/functionalities/Bat.dart';
// import 'package:pycnomobile/model/functionalities/Hum.dart';
// import 'package:pycnomobile/model/functionalities/Rain.dart';
// import 'package:pycnomobile/model/functionalities/Rssi.dart';
// import 'package:pycnomobile/model/TimeSeries.dart';
// import 'package:pycnomobile/model/functionalities/Temp.dart';
// import 'package:pycnomobile/model/functionalities/Functionality.dart';

// class RainGauge extends Sensor {
//   double? pw;

//   RainGauge({
//     required String uid,
//     required String? name,
//     required String? address,
//     required String? img,
//     required int? epoch,
//     required String? site,
//     required bool? isLive,
//     required int? isLiveHealth,
//     required DateTime? isLiveTS,
//     required DateTime? updatedAt,
//     required DateTime? polledAt,
//     required String? soilType,
//     required String? readableAgo,
//     required String? readableAgoFull,
//     required List<Functionality>? functionalities,
//     required this.pw,
//   }) : super(
//           type: TYPE_OF_SENSOR.RAIN_GAUGE,
//           uid: uid,
//           name: name,
//           address: address,
//           img: img,
//           epoch: epoch,
//           site: site,
//           isLive: isLive,
//           isLiveTS: isLiveTS,
//           isLiveHealth: isLiveHealth,
//           updatedAt: updatedAt,
//           polledAt: polledAt,
//           soilType: soilType,
//           readableAgo: readableAgo,
//           readableAgoFull: readableAgoFull,
//           functionalities: functionalities,
//         );

//   static bool isRainGauge(String uid) {
//     return uid.startsWith("K40");
//   }

//   factory RainGauge.fromJson(Map<String, dynamic> json) {
//     return RainGauge(
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
//             Sensor.getFunctionalities(json, TYPE_OF_SENSOR.RAIN_GAUGE));
//   }
// }
