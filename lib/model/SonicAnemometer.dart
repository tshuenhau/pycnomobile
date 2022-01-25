import 'Sensor.dart';
import 'package:pycnomobile/model/functionalities/Bat.dart';
import 'package:pycnomobile/model/functionalities/Gst.dart';
import 'package:pycnomobile/model/functionalities/Hum.dart';
import 'package:pycnomobile/model/functionalities/Lx1.dart';
import 'package:pycnomobile/model/functionalities/Rssi.dart';
import 'package:pycnomobile/model/functionalities/Temp.dart';
import 'package:pycnomobile/model/functionalities/Uv.dart';
import 'package:pycnomobile/model/functionalities/Wnd.dart';
import 'package:pycnomobile/model/functionalities/Wndr.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

class SonicAnemometer extends Sensor {
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
      required List<Functionality>? functionalities,
      required this.pw})
      : super(
            type: TYPE_OF_SENSOR.SONIC_ANEMOMETER,
            uid: uid,
            name: name,
            address: address,
            img: img,
            epoch: epoch,
            site: site,
            isLive: isLive,
            isLiveTS: isLiveTS,
            isLiveHealth: isLiveHealth,
            updatedAt: updatedAt,
            polledAt: polledAt,
            soilType: soilType,
            readableAgo: readableAgo,
            readableAgoFull: readableAgoFull,
            functionalities: functionalities);

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
        pw: json["PW"].toDouble(),
        functionalities: [
          new Temp(json["TEMP"].toDouble()),
          new Hum(json["HUM"].toDouble()),
          new Bat(json["BAT"].toDouble()),
          new Lx1(json["LX1"].toDouble()),
          new Uv(json["UV"].toDouble()),
          new Wnd(json["WND"].toDouble()),
          new Wndr(json["WNDR"].toDouble()),
          new Gst(json["GST"].toDouble()),
          new Rssi(json["RSSI"].toDouble()),
        ]);
  }
}
