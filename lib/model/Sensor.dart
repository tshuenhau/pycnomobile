import 'package:pycnomobile/model/sonicanemometer.dart';
import 'package:pycnomobile/model/raingauge.dart';
import 'package:pycnomobile/model/mastersoilsensor.dart';
import 'package:pycnomobile/model/nodesoilsensor.dart';

enum TYPE_OF_SENSOR {
  SONIC_ANEMOMETER,
  RAIN_GAUGE,
  MASTER_SOIL_SENSOR,
  NODE_SOIL_SENSOR
}

abstract class Sensor {
  TYPE_OF_SENSOR type;
  String uid;
  String name;
  String img;
  String address;
  int epoch;
  String site;
  bool isLive;
  int isLiveHealth;
  DateTime isLiveTS;
  DateTime updatedAt;
  DateTime polledAt;
  String soilType;
  String readableAgo;
  String readableAgoFull;

  Sensor(
      this.uid,
      this.name,
      this.img,
      this.address,
      this.epoch,
      this.site,
      this.isLive,
      this.isLiveTS,
      this.isLiveHealth,
      this.updatedAt,
      this.polledAt,
      this.soilType,
      this.readableAgo,
      this.readableAgoFull)
      : type = getTypeOfSensor(uid);

/**
   * Sonic Anemometer: K80xxxxx
   * Rain Gauge: K40xxxxx
   * Master Soil Sensor: Mxxx
   * Node Soil Sensor: Kxxx
   * 
   */
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
      throw Exception("Invalid sensor");
    }
  }
}
