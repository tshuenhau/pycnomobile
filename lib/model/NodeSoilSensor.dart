import 'SoilSensor.dart';

class NodeSoilSensor extends SoilSensor {
  double? pw;

  NodeSoilSensor(
      {required String uid,
      required String name,
      required String address,
      required String img,
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
      required double temp,
      required double hum,
      required double lw1,
      required String? txt,
      required double rainh,
      required int lfreq,
      required double ve,
      required double bat,
      required double rssi,
      required double? ns,
      required double? s1t,
      required double? s2t,
      required double? s3t,
      required double? s4t,
      required double? s5t,
      required double? s6t,
      required double? st1,
      required double? st3,
      required double? st5,
      required this.pw})
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
            temp: temp,
            hum: hum,
            lw1: lw1,
            txt: txt,
            rainh: rainh,
            lfreq: lfreq,
            ve: ve,
            bat: bat,
            rssi: rssi,
            ns: ns,
            s1t: s1t,
            s2t: s2t,
            s3t: s3t,
            s4t: s4t,
            s5t: s5t,
            s6t: s6t,
            st1: st1,
            st3: st3,
            st5: st5);

  static bool isNodeSoilSensor(String uid) {
    return uid.startsWith("K") &&
        !uid.startsWith("K40") &&
        !uid.startsWith("K80");
  }

  factory NodeSoilSensor.fromJson(Map<String, dynamic> json) => NodeSoilSensor(
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
        temp: json["TEMP"],
        hum: json["HUM"],
        txt: json["TXT"],
        rainh: json["RAINH"].toDouble(),
        lfreq: json["LFREQ"],
        ve: json["VE"],
        bat: json["BAT"],
        rssi: json["RSSI"].toDouble(),
        ns: json["NS"]?.toDouble(),
        s1t: json["S1T"],
        s2t: json["S2T"],
        s3t: json["S3T"],
        s4t: json["S4T"],
        s5t: json["S5T"],
        s6t: json["S6T"],
        st1: json["ST1"],
        st3: json["ST3"],
        st5: json["ST5"],
        lw1: json["LW1"],
        pw: json["PW"]?.toDouble(),
      );

  @override
  String toString() {
    return "Node Soil Sensor: " + super.toString();
  }
}
