import 'Sensor.dart';

class SonicAnemometer extends Sensor {
  double temp;
  double hum;
  double wnd;
  double gst;
  double wndr;
  double lx1;
  double uv;
  double bat;
  double rssi;
  double pw;

  SonicAnemometer(
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
      required this.wnd,
      required this.gst,
      required this.wndr,
      required this.lx1,
      required this.uv,
      required this.bat,
      required this.rssi,
      required this.pw})
      : super(
            TYPE_OF_SENSOR.SONIC_ANEMOMETER,
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

  static bool isSonicAnemometer(String uid) {
    return uid.startsWith("K80");
  }

  factory SonicAnemometer.fromJson(Map<String, dynamic> json) {
    return SonicAnemometer(
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
        wnd: json["WND"].toDouble(),
        gst: json["GST"].toDouble(),
        wndr: json["WNDR"].toDouble(),
        lx1: json["LX1"].toDouble(),
        uv: json["UV"].toDouble(),
        bat: json["BAT"],
        rssi: json["RSSI"].toDouble(),
        pw: json["PW"].toDouble());
  }
}
