import 'package:pycnomobile/model/sensors/Sensor.dart';

class Pulse extends Sensor {
  dynamic slil;
  dynamic slir;
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
      required this.slil,
      required this.slir,
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
        sli: json["SLI"],
        slil: json["SLIL"]["SID"],
        slir: json["SLIR"]["SID"],
        isSimActive: Sensor.getIsSimActive(json));
  }

  @override
  String toString() {
    return super.toString() +
        ' slil: ' +
        slil.toString() +
        " slir: " +
        slir.toString();
  }
}
