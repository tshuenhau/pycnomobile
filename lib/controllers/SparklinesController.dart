import 'dart:convert';
import 'package:get/get.dart';
import 'dart:async';
import 'package:Sensr/model/sensors/Sensor.dart';
import 'package:http/http.dart' as http;
import 'package:Sensr/model/TimeSeries.dart';
import 'package:Sensr/controllers/AuthController.dart';
import 'package:Sensr/model/functionalities/Functionality.dart';
import 'package:Sensr/model/sensors/Pulse.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:io';
import 'package:Sensr/env.dart';

class SparklinesController extends GetxController {
  AuthController authController = Get.find();
  RxList<RxMap<String, RxList<TimeSeries>>> sliSparklines =
      RxList<RxMap<String, RxList<TimeSeries>>>();
  RxList<RxMap<String, RxList<TimeSeries>>> sliAlertSparklines =
      RxList<RxMap<String, RxList<TimeSeries>>>();
  RxList<RxMap<String, RxList<TimeSeries>>> nonSliSparklines =
      RxList<RxMap<String, RxList<TimeSeries>>>();
  RxList<RxMap<String, RxList<TimeSeries>>> alertNonSliSparklines =
      RxList<RxMap<String, RxList<TimeSeries>>>();

  int intConcurrentCount = 3;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<SparklinesController>();
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

  Future<void> getSliSparklines(
      Sensor sensor, bool isAlert, DateTime oneDayBef, DateTime now) async {
    dynamic slil = (sensor as Pulse).slil; //left sli
    dynamic slir = (sensor).slir; //right sli
    for (dynamic sli in sensor.sli!) {
      String pid = sli["PID"].toString();
      dynamic sid = sli["SID"];

      if (sid == slil || sid == slir && (slil != 0 || slir != 0)) {
        RxList<TimeSeries> instanceList = RxList.empty(growable: true);
        int total = sli["plottable"].length;
        int count = 0;
        int starti = 0;
        while (total > 0) {
          List<String> nonNullFunctions = List.empty(growable: true);
          late final sublist;
          if (total - starti >= intConcurrentCount) {
            sublist =
                sli["plottable"].sublist(starti, starti + intConcurrentCount);
          } else {
            sublist = sli["plottable"].sublist(starti, starti + total);
          }
          starti += sublist.length as int;
          count = 0;
          for (String func in sublist) {
            if (total == 0) {
              break;
            }
            if (count < intConcurrentCount) {
              nonNullFunctions.add(func);
              count++;
            }
          }

          total -= intConcurrentCount;
          Iterable<Future<http.Response>> futureResponses =
              nonNullFunctions.map((String function) {
            Future<http.Response> response = http.get(Uri.parse(
                '$API_URL/data/1?TK=${authController.token}&UID=${sensor.uid}&PID=$pid&$function&start=${oneDayBef.toUtc().toIso8601String()}&end=${now.toUtc().toIso8601String()}'));
            return response;
          });
          final responses = await Future.wait(futureResponses);

          for (int i = 0; i < responses.length; i++) {
            http.Response res = responses[i];
            if (res.statusCode == 200) {
              if (jsonDecode(res.body).length <= 0) {
                continue;
              }

              var body = jsonDecode(res.body)[0];
              if (isAlert) {
                sliAlertSparklines.last[pid] = instanceList;
              } else {
                sliSparklines.last[pid] = instanceList;
              }

              String color = body['color'];
              String key = body['key'];

              if (body["values"] == null) {
                instanceList.add(new TimeSeries(
                    name: key,
                    color: color,
                    timeSeries: null,
                    key: nonNullFunctions[i]));
                continue;
              }
              Map<int, double> timeSeries = convertListToMap(body['values']);
              instanceList.add(new TimeSeries(
                  name: key,
                  color: color,
                  timeSeries: timeSeries,
                  key: nonNullFunctions[i]));
            } else {
              throw Exception("Failed to retrieve data. Try again!");
            }
          }
        }
      }
    }
  }

  Future<void> getNonSliSparklines(
      Sensor sensor, bool isAlert, DateTime oneDayBef, DateTime now) async {
    RxList<TimeSeries> instanceList = RxList.empty(growable: true);
    List<Functionality> functions = sensor.functionalities!;

    int total = functions.length;
    int count = 0;
    int starti = 0;
    while (total > 0) {
      List<Functionality> nonNullFunctions = List.empty(growable: true);
      late final sublist;
      if (total - starti >= intConcurrentCount) {
        sublist = functions.sublist(starti, starti + intConcurrentCount);
      } else {
        sublist = functions.sublist(starti, starti + total);
      }
      count = 0;
      for (Functionality? func in sublist) {
        if (total == 0) {
          break;
        }
        if (func != null && count < intConcurrentCount) {
          nonNullFunctions.add(func);
          count++;
        }
      }
      starti += count;
      total -= intConcurrentCount;
      Iterable<Future<http.Response>> futureResponses =
          nonNullFunctions.map((Functionality function) {
        Future<http.Response> response = http.get(Uri.parse(
            '$API_URL/data/1?TK=${authController.token}&UID=${sensor.uid}&${function.key}&start=${oneDayBef.toUtc().toIso8601String()}&end=${now.toUtc().toIso8601String()}'));
        return response;
      });

      final responses = await Future.wait(futureResponses);
      for (int i = 0; i < responses.length; i++) {
        http.Response res = responses[i];

        if (res.statusCode == 200) {
          if (jsonDecode(res.body).length <= 0) {
            continue;
          }
          var body = jsonDecode(res.body)[0];
          if (isAlert) {
            alertNonSliSparklines.last[sensor.name ?? ""] = instanceList;
          } else {
            nonSliSparklines.last[sensor.name ?? ""] = instanceList;
          }
          String color = body['color'];
          String key = body['key'];

          if (body["values"] != null) {
            if (body["values"][0][1] is String) {
              //Don't display any logs
              continue;
            }
          }
          if (body["values"] == null) {
            instanceList.add(new TimeSeries(
                name: key,
                color: color,
                timeSeries: null,
                key: nonNullFunctions[i].key));
            continue;
          }
          Map<int, double> timeSeries = convertListToMap(body['values']);
          instanceList.add(new TimeSeries(
              name: key,
              color: color,
              timeSeries: timeSeries,
              key: nonNullFunctions[i].key));
        } else {
          throw Exception("Failed to retrieve data"); //Ask UI to reload
          // }
        }
      }
    }
  }

  Future<void> getTimeSeriesForSparklines(Sensor sensor, bool isAlert) async {
    try {
      DateTime oneDayBef = DateTime.now().add(const Duration(hours: -24));
      if (isAlert) {
        sliAlertSparklines.add(RxMap());
        alertNonSliSparklines.add(RxMap());
      } else {
        sliSparklines.add(RxMap());
        nonSliSparklines.add(RxMap());
      }

      DateTime now = DateTime.now();
      if (sensor.isPulse()) {
        await getSliSparklines(sensor, isAlert, oneDayBef, now);
      }

      await getNonSliSparklines(sensor, isAlert, oneDayBef, now);

      if (sliSparklines.length > 1 && !isAlert) {
        sliSparklines.removeRange(0, sliSparklines.length - 1);
        nonSliSparklines.removeRange(0, nonSliSparklines.length - 1);
      } else if (sliAlertSparklines.length > 1) {
        sliAlertSparklines.removeRange(0, sliAlertSparklines.length - 1);
        alertNonSliSparklines.removeRange(0, alertNonSliSparklines.length - 1);
      }
    } on SocketException catch (e) {
      EasyLoading.showError(
          'Network Error: please check your internet connection.',
          duration: Duration(seconds: 3),
          dismissOnTap: true);
    }
  }
}
