import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/FixSensor.dart';
import 'package:pycnomobile/model/sensors/Pulse.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'dart:io';

class ListOfSensorsController extends GetxController
    with StateMixin<List<Sensor>> {
  late BuildContext context;
  RxList<Sensor> listOfSensors = List<Sensor>.empty(growable: true).obs;
  RxList<Sensor> filteredListOfSensors = List<Sensor>.empty(growable: true).obs;
  RxList<TimeSeries> listOfTimeSeries =
      List<TimeSeries>.empty(growable: true).obs;
  Rx<String> searchController = ''.obs;
  Rx<DateTime> lastRefreshTime = DateTime.now().obs;
  Rx<DateTime> lastPausedTime = DateTime.now().obs;
  RxList<Sensor> inactiveListOfSensors = List<Sensor>.empty(growable: true).obs;

  AuthController authController = Get.find();

  @override
  void onInit() async {
    this.reload();
    super.onInit();
    try {
      EasyLoading.show(status: 'Loading...');
      await getListOfSensors();
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.showError('$err');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void reload() {
    Timer.periodic(new Duration(seconds: 5), (timer) async {
      // print("reload");
      if (ModalRoute.of(context)!.isCurrent &&
          authController.currentTab.value == 0 &&
          lastRefreshTime.value
              .isBefore(DateTime.now().add(const Duration(seconds: -900)))) {
        // wait for 15 minutes before refreshing
        try {
          EasyLoading.show(status: 'Loading...');
          await getListOfSensors();
          lastRefreshTime.value = DateTime.now();
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
    try {
      final response = await http.get(Uri.parse(
          'https://stage.pycno.co.uk/api/v2/data/nodelist.json?TK=${authController.token}'));
      print("RES " + response.statusCode.toString());
      if (response.statusCode == 200) {
        listOfSensors.clear();
        filteredListOfSensors.clear();
        var body = jsonDecode(response.body);

        for (var i = 0; i < body.length; i++) {
          if (body[i]["SLI"] != null) {
            //PULSE
            addSensor(Pulse.fromJson(body[i]));
          } else {
            addSensor(FixSensor.fromJson(body[i]));
          }
        }

        sortSensors();

        this.lastRefreshTime.value = DateTime.now();
      } else {
        throw Exception(
            "Failed to retrieve list of sensors"); //Ask UI to reload
      }
    } on SocketException catch (e) {
      throw SocketException("No internet!");
    }
  }

  void sortSensors() {
    // List<Sensor> activeList = List.empty(growable: true);
    List<Sensor> allSensorList = List.empty(growable: true);
    List<Sensor> inactiveList = List.empty(growable: true);
    if (filteredListOfSensors.length <= 1) {
      return;
    }
    for (Sensor s in filteredListOfSensors) {
      if (s.isActive() == IS_ACTIVE.INACTIVE) {
        inactiveList.insert(0, s);
        allSensorList.insert(0, s);
      } else {
        allSensorList.insert(0, s);
      }
    }

    //sorting inactive list by date
    // inactiveList.sort((a, b) => a.polledAt != null && b.polledAt != null
    //     ? a.polledAt!.compareTo(b.polledAt!)
    //     : 0);

    inactiveList = inactiveList.reversed.toList();
    inactiveListOfSensors.value = inactiveList;

    List<Sensor> tempList = [...allSensorList];

    Map<Sensor, List<Sensor>> sensorMap = {};

    // create empty list for each non-node sensor
    for (int i = 0; i < tempList.length; i++) {
      if (!tempList[i].uid.startsWith("K")) {
        sensorMap[tempList[i]] = List.empty(growable: true);
      }
    }

    Iterable<Sensor> masterSensors = sensorMap.keys;

    //add node sensors to master
    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].uid.startsWith("K")) {
        for (Sensor master in masterSensors) {
          if (master.uid == tempList[i].site) {
            sensorMap[master]!.add(tempList[i]);
          }
        }
      }
    }

    //sort all the node sensors
    for (Sensor master in masterSensors) {
      sensorMap[master]!.sort((a, b) => a.polledAt != null && b.polledAt != null
          ? b.polledAt!.compareTo(a.polledAt!)
          : 0);
    }

    //sort all the non-node sensors
    List<Sensor> masterSensorsList = masterSensors.toList();
    masterSensorsList.sort((a, b) => a.polledAt != null && b.polledAt != null
        ? b.polledAt!.compareTo(a.polledAt!)
        : 0);
    List<Sensor> list = List.empty(growable: true);
    for (int i = 0; i < masterSensorsList.length; i++) {
      Sensor currentSensor = masterSensorsList[i];
      //current sensor is a master sensor
      list.add(currentSensor);
      list.addAll(sensorMap[currentSensor] ?? []);
    }

    //Add nodes in case no masters
    for (int i = 0; i < tempList.length; i++) {
      if (!list.contains(tempList[i])) {
        list.add(tempList[i]);
      }
    }

    filteredListOfSensors.value = [...list];
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
      sortSensors();
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

    sortSensors();
  }
}
