import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/MasterSoilSensor.dart';
import 'package:pycnomobile/model/sensors/SonicAnemometer.dart';
import 'package:pycnomobile/model/sensors/NodeSoilSensor.dart';
import 'package:pycnomobile/model/sensors/RainGauge.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/AuthController.dart';

class ListOfSensorsController extends GetxController
    with StateMixin<List<Sensor>> {
  late BuildContext context;
  RxList<Sensor> listOfSensors = List<Sensor>.empty(growable: true).obs;
  RxList<Sensor> filteredListOfSensors = List<Sensor>.empty(growable: true).obs;
  RxList<TimeSeries> listOfTimeSeries =
      List<TimeSeries>.empty(growable: true).obs;
  Rx<String> searchController = ''.obs;
  Rx<DateTime> lastRefreshTime = DateTime.now().obs;

  late AuthController authController;

  @override
  void onInit() async {
    super.onInit();
    authController = Get.find();
    try {
      EasyLoading.show(status: 'loading...');
      await getListOfSensors();
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.showError('$err');
    }
    await this.reload();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> reload() async {
    Timer.periodic(new Duration(seconds: 5), (timer) async {
      if (ModalRoute.of(context)!.isCurrent &&
          authController.currentTab.value == 0 &&
          lastRefreshTime.value
              .isBefore(DateTime.now().add(const Duration(seconds: -6000)))) {
        print("refresh sensors");
        try {
          EasyLoading.show(status: 'loading...');

          await getListOfSensors();

          EasyLoading.dismiss();
        } catch (err) {
          EasyLoading.showError('$err');
        }
      }
    });
  }

  void addSensor(Sensor sensor) {
    listOfSensors.add(sensor);
    filteredListOfSensors.add(sensor);
  }

  Future<void>? getListOfSensors() async {
    print(authController.token + " token, getting list of sensors!");
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/data/nodelist.json?TK=${authController.token}'));

    // print(
    //     'https://stage.pycno.co.uk/api/v2/data/nodelist.json?TK=${authController.token}');
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
      filteredListOfSensors.sort((a, b) =>
          a.polledAt != null && b.polledAt != null
              ? b.polledAt!.compareTo(a.polledAt!)
              : 0);

      this.lastRefreshTime.value = DateTime.now();
    } else {
      throw Exception("Failed to retrieve list of sensors"); //Ask UI to reload
    }
  }

  void searchListOfSensors() {
    String searchTerm = searchController.value;
    filteredListOfSensors.clear();
    if (searchTerm == "") {
      List<Sensor> tempList = List<Sensor>.empty(growable: true);
      for (Sensor sensor in listOfSensors) {
        tempList.add(sensor);
      }
      filteredListOfSensors.value = tempList.reversed.toList();
      return;
    }

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
