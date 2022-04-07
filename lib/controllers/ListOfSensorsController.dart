import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/notinuse/SonicAnemometer.dart';
import 'package:pycnomobile/model/sensors/FixSensor.dart';
import 'package:pycnomobile/model/sensors/notinuse/RainGauge.dart';
import 'package:pycnomobile/model/sensors/Pulse.dart';
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

  AuthController authController = Get.find();

  @override
  void onInit() async {
    super.onInit();
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
  void onClose() {
    super.onClose();
  }

  Future<void> reload() async {
    Timer.periodic(new Duration(seconds: 5), (timer) async {
      if (ModalRoute.of(context)!.isCurrent &&
          authController.currentTab.value == 0 &&
          lastRefreshTime.value
              .isBefore(DateTime.now().add(const Duration(seconds: -900)))) {
        // wait for 15 minutes before refreshing
        print("refresh sensors");
        try {
          EasyLoading.show(status: 'loading...');
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
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/data/nodelist.json?TK=${authController.token}'));

    // print(
    //     'https://stage.pycno.co.uk/api/v2/data/nodelist.json?TK=${authController.token}');
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
        // TYPE_OF_SENSOR type = Sensor.getTypeOfSensor(body[i]["UID"]);
        // if (type == TYPE_OF_SENSOR.MASTER_SOIL_SENSOR) {
        //   addSensor(MasterSoilSensor.fromJson(body[i]));
        // } else if (type == TYPE_OF_SENSOR.NODE_SOIL_SENSOR) {
        //   addSensor(NodeSoilSensor.fromJson(body[i]));
        // } else if (type == TYPE_OF_SENSOR.SONIC_ANEMOMETER) {
        //   addSensor(SonicAnemometer.fromJson(body[i]));
        // } else if (type == TYPE_OF_SENSOR.RAIN_GAUGE) {
        //   addSensor(RainGauge.fromJson(body[i]));
        // } else if (type == TYPE_OF_SENSOR.PULSE) {
        //   addSensor(Pulse.fromJson(body[i]));
        // } else {
        //   addSensor(NodeSoilSensor.fromJson(body[i]));
        // }
      }

      sortSensors();

      this.lastRefreshTime.value = DateTime.now();
    } else {
      throw Exception("Failed to retrieve list of sensors"); //Ask UI to reload
    }
  }

  void sortSensors() {
    List<Sensor> activeList = List.empty(growable: true);
    List<Sensor> inactiveList = List.empty(growable: true);
    for (Sensor s in filteredListOfSensors) {
      if (DateTimeRange(
                  start: DateTime.fromMillisecondsSinceEpoch(s.epoch!),
                  end: DateTime.now())
              .duration
              .inHours >
          24) {
        inactiveList.insert(0, s);
      } else {
        activeList.insert(0, s);
      }
    }

    //sorting inactive list
    inactiveList.sort((a, b) => a.polledAt != null && b.polledAt != null
        ? b.polledAt!.compareTo(a.polledAt!)
        : 0);

    List<Sensor> tempList = [...activeList];
    for (Sensor sensor in activeList) {
      if (sensor.uid.startsWith("K")) {
        for (Sensor tempS in tempList) {
          if (tempS.uid == sensor.site) {
            //tempS = master sensor and sensor = node sensor
            print("master sensor " + tempS.uid);
            print("node sensor " + sensor.uid);
            print("node sensor site " + sensor.site!);
            int i = tempList.indexWhere(
                (Sensor s) => s.uid == sensor.uid); //index of node sensor
            int j = tempList.indexWhere((Sensor s) => s.uid == tempS.uid);
            Sensor node = tempList.removeAt(i);
            if (j + 1 > tempList.length) {
              tempList.add(node);
            } else {
              tempList.insert(j + 1, node);
            }

            print(tempList);
          }
        }
      }
    } //a  is master, b is node
    activeList.sort((a, b) => (b.site == a.uid || b.site == a.site)
        ? 0
        : a.polledAt != null && b.polledAt != null
            ? b.polledAt!.compareTo(a.polledAt!)
            : 0);
    activeList.addAll(inactiveList);
    filteredListOfSensors.value = [...activeList];
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
  }
}
