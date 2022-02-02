import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:pycnomobile/model/sensors/MasterSoilSensor.dart';
import 'package:pycnomobile/model/sensors/SonicAnemometer.dart';
import 'package:pycnomobile/model/sensors/NodeSoilSensor.dart';
import 'package:pycnomobile/model/sensors/RainGauge.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/logic/Commons.dart';

class ListOfSensorsController extends GetxController {
  RxList<Sensor> listOfSensors = List<Sensor>.empty().obs;

  @override
  void onInit() async {
    super.onInit();
    await getListOfSensors();
  }

  void addSensor(Sensor sensor) {
    listOfSensors.add(sensor);
  }

  void removeSensor(Sensor sensorToRemove) {
    listOfSensors
        .removeWhere((Sensor sensor) => sensor.uid == sensorToRemove.uid);
  }

  void updateSensor(Sensor updatedSensor) {}

  Future<List<Sensor>>? getListOfSensors() async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/nodelist.json?TK=$token'));

    if (response.statusCode == 200) {
      listOfSensors.clear();
      var body = jsonDecode(response.body);
      for (var i = 0; i < body.length; i++) {
        TYPE_OF_SENSOR type = Sensor.getTypeOfSensor(body[i]["UID"]);
        if (type == TYPE_OF_SENSOR.MASTER_SOIL_SENSOR) {
          addSensor(MasterSoilSensor.fromJson(body[i]));
        } else if (type == TYPE_OF_SENSOR.NODE_SOIL_SENSOR) {
          addSensor(NodeSoilSensor.fromJson(body[i]));
        } else if (type == TYPE_OF_SENSOR.SONIC_ANEMOMETER) {
          addSensor(SonicAnemometer.fromJson(body[i]));
        } else if (type == TYPE_OF_SENSOR.RAIN_GAUGE) {
          addSensor(RainGauge.fromJson(body[i]));
        }
      }
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
    return listOfSensors;
  }
}
