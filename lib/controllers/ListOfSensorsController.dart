import 'package:get/get.dart';
import 'package:pycnomobile/model/sensor.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/logic/Commons.dart';
import 'dart:convert';

class ListOfSensorsControllers extends GetxController {
  List<Sensor> listOfSensors = List<Sensor>.empty().obs;

  void addSensor(Sensor sensor) {
    listOfSensors.add(sensor);
  }

  void removeSensor(Sensor sensorToRemove) {
    listOfSensors
        .removeWhere((Sensor sensor) => sensor.uid == sensorToRemove.uid);
  }

  void updateSensor(Sensor updatedSensor) {}

  static getListOfSensors() async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/nodelist.json?TK=${token}'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      for (var i = 0; i < body.length; i++) {
        TYPE_OF_SENSOR type = Sensor.getTypeOfSensor(body[i]["uid"]);
        if (type == TYPE_OF_SENSOR.MASTER_SOIL_SENSOR) {
        } else if (type == TYPE_OF_SENSOR.NODE_SOIL_SENSOR) {}
      }
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }
}
