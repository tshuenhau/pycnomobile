import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SensorInfoController extends GetxController {
  AuthController authController = Get.find();
  RxMap<String, RxList<TimeSeries>> sparkLines =
      RxMap<String, RxList<TimeSeries>>();
  RxMap<String, RxList<TimeSeries>> nonSliSparklines =
      RxMap<String, RxList<TimeSeries>>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<SensorInfoController>();
    super.onClose();
  }

  List<double> convertTimeSeriestoList(Map<int, double> timeSeries) {
    List<double> list = [];
    timeSeries.forEach((key, value) {
      list.insert(list.length, value);
    });
    return list;
  }

  static Map<int, double> convertListToMap(List list) {
    return Map.fromIterable(list.reversed.where((e) => e[1] != null),
        key: (e) => e[0].toInt(), value: (e) => e[1].toDouble());
  }

  Future<void> getTimeSeriesForSparklines(Sensor sensor) async {
    DateTime twelveHrsBef = DateTime.now().add(const Duration(days: -3));
    DateTime now = DateTime.now();
    if (sensor.sli == null) {
      return;
    }
    if (sensor.isPulse()) {
      for (dynamic sli in sensor.sli!) {
        String pid = sli["PID"].toString();
        RxList<TimeSeries> instanceList = RxList.empty(growable: true);
        for (String functionality in sli["plottable"]) {
          final response = await http.get(Uri.parse(
              'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&PID=${sli["PID"]}&$functionality&start=${twelveHrsBef.toUtc().toIso8601String()}&end=${now.toUtc().toIso8601String()}'));
          if (response.statusCode == 200) {
            if (jsonDecode(response.body).length <= 0) {
              continue;
            }
            var body = jsonDecode(response.body)[0];
            print(body);
            String color = body['color'];
            String key = body['key'];
            sparkLines[pid] = instanceList;

            if (body["values"] == null) {
              instanceList.add(
                  new TimeSeries(key: key, color: color, timeSeries: null));
              continue;
            }
            Map<int, double> timeSeries = convertListToMap(body['values']);
            instanceList.add(
                new TimeSeries(key: key, color: color, timeSeries: timeSeries));
          } else {
            throw Exception("Failed to retrieve data"); //Ask UI to reload
          }
        }
      }
    }

    RxList<TimeSeries> instanceList = RxList.empty(growable: true);
    for (Functionality functionality in sensor.functionalities!) {
      final response = await http.get(Uri.parse(
          'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${functionality.key}&start=${twelveHrsBef.toUtc().toIso8601String()}&end=${now.toUtc().toIso8601String()}'));
      if (response.statusCode == 200) {
        if (jsonDecode(response.body).length <= 0) {
          continue;
        }
        var body = jsonDecode(response.body)[0];
        String color = body['color'];
        String key = body['key'];
        nonSliSparklines[sensor.name ?? " "] = instanceList;

        if (body["values"] == null) {
          instanceList
              .add(new TimeSeries(key: key, color: color, timeSeries: null));
          continue;
        }
        Map<int, double> timeSeries = convertListToMap(body['values']);
        instanceList.add(
            new TimeSeries(key: key, color: color, timeSeries: timeSeries));
      } else {
        throw Exception("Failed to retrieve data"); //Ask UI to reload
      }
    }
  }
}
