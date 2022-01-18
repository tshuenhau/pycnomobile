import '/model/MasterSoilSensor.dart';
import '/model/NodeSoilSensor.dart';
import '/model/SonicAnemometer.dart';
import '/model/RainGauge.dart';

class Logic {
  /**
   * Sonic Anemometer: K80xxxxx
   * Rain Gauge: K40xxxxx
   * Master Soil Sensor: Mxxx
   * Node Soil Sensor: Kxxx
   * 
   */
  String getTypeOfSensor(String uid) {
    if (SonicAnemometer.isSonicAnemometer(uid)) {
      return SonicAnemometer.SENSOR_TYPE;
    } else if (RainGauge.isRainGauge(uid)) {
      return RainGauge.SENSOR_TYPE;
    } else if (MasterSoilSensor.isMasterSoilSensor(uid)) {
      return MasterSoilSensor.SENSOR_TYPE;
    } else if (NodeSoilSensor.isNodeSoilSensor(uid)) {
      return NodeSoilSensor.SENSOR_TYPE;
    } else {
      throw Exception("Invalid sensor");
    }
  }
}
