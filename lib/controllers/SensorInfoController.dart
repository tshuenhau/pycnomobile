import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/model/sensors/Pulse.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SensorInfoController extends GetxController {
  AuthController authController = Get.find();
  RxMap<String, RxList<TimeSeries>> sparkLines =
      RxMap<String, RxList<TimeSeries>>();
  RxMap<String, RxList<TimeSeries>> alertSparklines =
      RxMap<String, RxList<TimeSeries>>();
  RxMap<String, RxList<TimeSeries>> nonSliSparklines =
      RxMap<String, RxList<TimeSeries>>();
  RxMap<String, RxList<TimeSeries>> alertNonSliSparklines =
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

  List<double>? convertTimeSeriestoList(Map<int, double>? timeSeries) {
    if (timeSeries == null) {
      return null;
    }
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

  Future<void> getTimeSeriesForSparklines(Sensor sensor, bool isAlert) async {
    print("IS ALERT: " + isAlert.toString());
    DateTime oneDayBef = DateTime.now().add(const Duration(hours: -24));

    DateTime now = DateTime.now();
    if (sensor.isPulse()) {
      dynamic slil = (sensor as Pulse).slil; //left sli
      dynamic slir = (sensor).slir; //right sli
      for (dynamic sli in sensor.sli!) {
        String pid = sli["PID"].toString();
        dynamic sid = sli["SID"];

        if (sid == slil || sid == slir && (slil != 0 || slir != 0)) {
          RxList<TimeSeries> instanceList = RxList.empty(growable: true);
          for (String functionality in sli["plottable"]) {
            final response = await http.get(Uri.parse(
                'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&PID=$pid&$functionality&start=${oneDayBef.toUtc().toIso8601String()}&end=${now.toUtc().toIso8601String()}'));
            if (response.statusCode == 200) {
              if (jsonDecode(response.body).length <= 0) {
                continue;
              }
              var body = jsonDecode(response.body)[0];

              String color = body['color'];
              String key = body['key'];
              if (isAlert) {
                alertSparklines[pid] = instanceList;
              } else {
                sparkLines[pid] = instanceList;
              }

              if (body["values"] == null) {
                instanceList.add(new TimeSeries(
                    name: key,
                    color: color,
                    timeSeries: null,
                    key: functionality));
                continue;
              }
              Map<int, double> timeSeries = convertListToMap(body['values']);
              instanceList.add(new TimeSeries(
                  name: key,
                  color: color,
                  timeSeries: timeSeries,
                  key: functionality));
            } else {
              throw Exception("Failed to retrieve data. Try again!");
            }
          }
        }
      }
    }
    RxList<TimeSeries> instanceList = RxList.empty(growable: true);
    for (Functionality? functionality in sensor.functionalities!) {
      if (functionality != null) {
        if (functionality.value is List) {
          List func = functionality.value;

          for (Functionality? subfunc in func) {
            if (subfunc != null) {
              final response = await http.get(Uri.parse(
                  'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${subfunc.key}&start=${oneDayBef.toUtc().toIso8601String()}&end=${now.toUtc().toIso8601String()}'));
              if (response.statusCode == 200) {
                if (jsonDecode(response.body).length <= 0) {
                  continue;
                }
                var body = jsonDecode(response.body)[0];

                String color = body['color'];
                String key = body['key'];
                if (body["values"] == null) {
                  instanceList.add(new TimeSeries(
                      name: key,
                      color: color,
                      timeSeries: null,
                      key: subfunc.key));
                  continue;
                }
                Map<int, double> timeSeries = convertListToMap(body['values']);
                instanceList.add(new TimeSeries(
                    name: key,
                    color: color,
                    timeSeries: timeSeries,
                    key: subfunc.key));
              } else {
                throw Exception("Failed to retrieve data"); //Ask UI to reload
              }
            }
          }
        } else {
          final response = await http.get(Uri.parse(
              'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${functionality.key}&start=${oneDayBef.toUtc().toIso8601String()}&end=${now.toUtc().toIso8601String()}'));

          if (response.statusCode == 200) {
            if (jsonDecode(response.body).length <= 0) {
              continue;
            }
            var body = jsonDecode(response.body)[0];
            String color = body['color'];
            String key = body['key'];

            if (isAlert) {
              alertNonSliSparklines[sensor.name ?? ""] = instanceList;
            } else {
              nonSliSparklines[sensor.name ?? ""] = instanceList;
            }
            if (body["values"] == null) {
              instanceList.add(new TimeSeries(
                  name: key,
                  color: color,
                  timeSeries: null,
                  key: functionality.key));
              continue;
            }
            Map<int, double> timeSeries = convertListToMap(body['values']);
            instanceList.add(new TimeSeries(
                name: key,
                color: color,
                timeSeries: timeSeries,
                key: functionality.key));
          } else {
            throw Exception("Failed to retrieve data. Try again!");
          }
        }
      }
    }
  }
}
