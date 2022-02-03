import 'package:pycnomobile/model/sensors/sonicanemometer.dart';
import 'package:pycnomobile/model/sensors/raingauge.dart';
import 'package:pycnomobile/model/sensors/MasterSoilSensor.dart';
import 'package:pycnomobile/model/sensors/NodeSoilSensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

enum TYPE_OF_SENSOR {
  SONIC_ANEMOMETER,
  RAIN_GAUGE,
  MASTER_SOIL_SENSOR,
  NODE_SOIL_SENSOR,
  PULSE
}

abstract class Sensor {
  TYPE_OF_SENSOR type;
  String uid;
  String? name;
  String? img;
  String? address;
  int epoch;
  String site;
  bool isLive;
  int isLiveHealth;
  DateTime isLiveTS;
  DateTime updatedAt;
  DateTime polledAt;
  String? soilType;
  String readableAgo;
  String readableAgoFull;
  List<Functionality>? functionalities;

  Sensor(
      {required this.type,
      required this.uid,
      required this.name,
      required this.img,
      required this.address,
      required this.epoch,
      required this.site,
      required this.isLive,
      required this.isLiveTS,
      required this.isLiveHealth,
      required this.updatedAt,
      required this.polledAt,
      required this.soilType,
      required this.readableAgo,
      required this.readableAgoFull,
      required this.functionalities});

  // Sonic Anemometer: K80xxxxx
  // Rain Gauge: K40xxxxx
  // Master Soil Sensor: Mxxx
  // Node Soil Sensor: Kxxx
  // Pulse: Pxxx
  //
  static TYPE_OF_SENSOR getTypeOfSensor(String uid) {
    if (SonicAnemometer.isSonicAnemometer(uid)) {
      return TYPE_OF_SENSOR.SONIC_ANEMOMETER;
    } else if (RainGauge.isRainGauge(uid)) {
      return TYPE_OF_SENSOR.RAIN_GAUGE;
    } else if (MasterSoilSensor.isMasterSoilSensor(uid)) {
      return TYPE_OF_SENSOR.MASTER_SOIL_SENSOR;
    } else if (NodeSoilSensor.isNodeSoilSensor(uid)) {
      return TYPE_OF_SENSOR.NODE_SOIL_SENSOR;
    } else {
      // throw Exception("Invalid sensor");
      return TYPE_OF_SENSOR.PULSE; //temporary
    }
  }

  // static List<Functionality> getFunctionalities(String uid) {
  //   List<Functionality> functionalities =
  //       List<Functionality>.empty(growable: true);
  //   if (SonicAnemometer.isSonicAnemometer(uid)) {
  //     functionalities.addAll([
  //       new Bat(),
  //       new Temp(),
  //       new Hum(),
  //       new Wnd(),
  //       new Gst(),
  //       new Wndr(),
  //       new Lx1(),
  //       new Uv(),
  //       new Rssi()
  //     ]);
  //   } else if (RainGauge.isRainGauge(uid)) {
  //     functionalities
  //         .addAll([new Bat(), new Temp(), new Hum(), new Rain(), new Rssi()]);
  //   } else if (MasterSoilSensor.isMasterSoilSensor(uid)) {
  //     functionalities.addAll([
  //       new Bat(),
  //       new Temp(),
  //       new Hum(),
  //       new Lx1(),
  //       new Lw1(),
  //       new Rainh(),
  //       new Rssi(),
  //       new S1t(),
  //       new S2t(),
  //       new S3t(),
  //       new S4t(),
  //       new S5t(),
  //       new S6t(),
  //       new St1(),
  //       new St3(),
  //       new St5(),
  //     ]);
  //   } else if (NodeSoilSensor.isNodeSoilSensor(uid)) {
  //     functionalities.addAll([
  //       new Bat(),
  //       new Temp(),
  //       new Hum(),
  //       new Lx1(),
  //       new Lw1(),
  //       new Rainh(),
  //       new Rssi(),
  //       new S1t(),
  //       new S2t(),
  //       new S3t(),
  //       new S4t(),
  //       new S5t(),
  //       new S6t(),
  //       new St1(),
  //       new St3(),
  //       new St5(),
  //     ]);
  //   } else {
  //     // throw Exception("Invalid sensor");
  //   }
  //   return functionalities;
  // }

  String toString() {
    return "UID: $uid, Name: $name, Img: $img, Address: $address, Epoch: $epoch, Site: $site, IsLive?: $isLive, IsLiveHealth: $isLiveHealth, IsLiveTS: $isLiveTS, UpdatedAt: $updatedAt, PolledAt: $polledAt, SoilType: $soilType, ReadableAgo: $readableAgo, ReadableAgoFull: $readableAgoFull";
  }
}
