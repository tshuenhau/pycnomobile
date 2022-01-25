import 'Sensor.dart';

class RainGauge extends Sensor {
  double temp;
  double hum;
  double rain;
  double bat;
  double? rssi;
  double pw;

  RainGauge(
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
      required this.temp,
      required this.hum,
      required this.rain,
      required this.bat,
      required this.rssi,
      required this.pw})
      : super(
            TYPE_OF_SENSOR.RAIN_GAUGE,
            uid,
            name,
            address,
            img,
            epoch,
            site,
            isLive,
            isLiveTS,
            isLiveHealth,
            updatedAt,
            polledAt,
            soilType,
            readableAgo,
            readableAgoFull);

  static bool isRainGauge(String uid) {
    return uid.startsWith("K40");
  }

  factory RainGauge.fromJson(Map<String, dynamic> json) {
    return RainGauge(
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
        rain: json["RAIN"].toDouble(),
        temp: json["TEMP"].toDouble(),
        hum: json["HUM"].toDouble(),
        bat: json["BAT"].toDouble(),
        rssi: json["RSSI"].toDouble(),
        pw: json["PW"].toDouble());
  }
}
