import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:pycnomobile/model/sensors/MasterSoilSensor.dart';
import 'package:pycnomobile/model/sensors/SonicAnemometer.dart';
import 'package:pycnomobile/model/sensors/NodeSoilSensor.dart';
import 'package:pycnomobile/model/sensors/RainGauge.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/controllers/AuthController.dart';

class ListOfSensorsController extends GetxController {
  RxList<Sensor> listOfSensors = List<Sensor>.empty(growable: true).obs;
  RxList<Sensor> filteredListOfSensors = List<Sensor>.empty(growable: true).obs;
  Rx<String> searchController = ''.obs;
  late AuthController authController;

  @override
  void onInit() async {
    authController = Get.find();
    print("Initating...");
    super.onInit();
    await getListOfSensors();
  }

  void addSensor(Sensor sensor) {
    listOfSensors.add(sensor);
    filteredListOfSensors.add(sensor);
  }

  Future<void>? getListOfSensors() async {
    print(authController.token + " token, getting list of sensors!");
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/data/nodelist.json?TK=${authController.token}'));
    if (response.statusCode == 200) {
      listOfSensors.clear();
      filteredListOfSensors.clear();
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
      throw Exception("Failed to retrieve list of sensors"); //Ask UI to reload
    }
  }

  void searchListOfSensors() {
    filteredListOfSensors.clear();
    String searchTerm = searchController.value;
    for (Sensor sensor in listOfSensors) {
      if (sensor.uid.contains(new RegExp(searchTerm, caseSensitive: false))) {
        filteredListOfSensors.add(sensor);
      } else if (sensor.name != null &&
          sensor.name!.contains(new RegExp(searchTerm, caseSensitive: false))) {
        filteredListOfSensors.add(sensor);
      } else if (sensor.address != null &&
          sensor.address!
              .contains(new RegExp(searchTerm, caseSensitive: false))) {
        filteredListOfSensors.add(sensor);
      }
    }
  }
}
