import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:pycnomobile/model/sensors/MasterSoilSensor.dart';
import 'package:pycnomobile/model/sensors/SonicAnemometer.dart';
import 'package:pycnomobile/model/sensors/NodeSoilSensor.dart';
import 'package:pycnomobile/model/sensors/RainGauge.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/controllers/AuthController.dart';

class ListOfSensorsController extends GetxController {
  RxList<Sensor> listOfSensors = List<Sensor>.empty().obs;
  TextEditingController searchController = new TextEditingController();
  AuthController authController = Get.find();

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
    print(authController.token);
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/data/nodelist.json?TK=${authController.token}'));
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
      print(listOfSensors.length);
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
    return listOfSensors;
  }

  List<Sensor> searchListOfSensors() {
    List<Sensor> searchedListOfSensors = List<Sensor>.empty(growable: true);

    String searchTerm = searchController.text;
    for (Sensor sensor in listOfSensors) {
      if (sensor.uid.contains(new RegExp(searchTerm, caseSensitive: false))) {
        searchedListOfSensors.add(sensor);
      } else if (sensor.name != null &&
          sensor.name!.contains(new RegExp(searchTerm, caseSensitive: false))) {
        searchedListOfSensors.add(sensor);
      } else if (sensor.address != null &&
          sensor.address!
              .contains(new RegExp(searchTerm, caseSensitive: false))) {
        searchedListOfSensors.add(sensor);
      }
    }
    return searchedListOfSensors;
  }
}
