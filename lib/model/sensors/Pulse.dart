import 'package:pycnomobile/model/sensors/Sensor.dart';

class Pulse extends Sensor {
  Pulse(
      {required uid,
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
      required sli,
      required isSimActive})
      : super(
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
            functionalities: functionalities,
            sli: sli,
            isSimActive: isSimActive);

  static List<dynamic> getSli(Map<String, dynamic> json) {
    return json["SLI"];
  }

  factory Pulse.fromJson(Map<String, dynamic> json) {
    return Pulse(
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
        functionalities: Sensor.getFunctionalities(json, TYPE_OF_SENSOR.PULSE),
        sli: getSli(json),
        isSimActive: Sensor.getIsSimActive(json));
  }
}
