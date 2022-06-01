import 'package:Sensr/model/functionalities/Functionality.dart';
import 'package:Sensr/model/sensors/Sensor.dart';

class FixSensor extends Sensor {
  FixSensor(
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
            sli: sli,
            readableAgoFull: readableAgoFull,
            functionalities: functionalities,
            isSimActive: isSimActive);

  static getFunctionalities(Map<String, dynamic> json) {
    List<Functionality> functionalities = List.empty(growable: true);

    for (var i = 0; i < json["plottable"].length; i++) {
      functionalities.add(new Functionality(
          value: json[json["plottable"][i]],
          unit: "",
          name: json["plottable"][i],
          color: null,
          icon: null,
          key: json["plottable"][i]));
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
        sli: json["SLI"],
        isLive: json["isLive"] == "YES",
        isLiveHealth: json["isLiveHealth"],
        isLiveTS: DateTime.parse(json["isLiveTS"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        polledAt: DateTime.parse(json["polledAt"]),
        soilType: json["soilType"],
        readableAgo: json["readableAgo"],
        readableAgoFull: json["readableAgoFull"],
        functionalities: getFunctionalities(json),
        isSimActive: Sensor.getIsSimActive(json));
  }

  @override
  FixSensor clone() {
    return new FixSensor(
        uid: this.uid,
        name: this.name,
        address: this.address,
        img: this.img,
        epoch: this.epoch,
        site: this.site,
        isLive: this.isLive,
        isLiveHealth: this.isLiveHealth,
        isLiveTS: this.isLiveTS,
        updatedAt: this.updatedAt,
        polledAt: this.polledAt,
        soilType: this.soilType,
        readableAgo: this.readableAgo,
        sli: this.sli,
        readableAgoFull: this.readableAgoFull,
        functionalities: this.functionalities,
        isSimActive: this.isSimActive);
  }
}
