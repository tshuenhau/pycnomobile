import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:Sensr/model/sensors/Sensor.dart';
import 'package:Sensr/model/sensors/Pulse.dart';
import 'package:http/http.dart' as http;
import 'package:Sensr/model/TimeSeries.dart';
import 'package:Sensr/model/LogSeries.dart';
import 'package:Sensr/controllers/AuthController.dart';
import 'package:Sensr/model/functionalities/Functionality.dart';
import 'dart:io';

class TimeSeriesController extends GetxController {
  AuthController authController = Get.find();
  RxList<RxList<TimeSeries>> graphs = RxList<RxList<TimeSeries>>.empty();
  RxList<RxList<TimeSeries>> alertGraphs = RxList<RxList<TimeSeries>>.empty();

  int intConcurrentCount = 3;

  RxList<RxMap<String, RxList<TimeSeries>>> oldSliGraphs =
      RxList<RxMap<String, RxList<TimeSeries>>>.empty();

  RxList<RxMap<String, RxList<TimeSeries>>> oldSliAlertGraphs =
      RxList<RxMap<String, RxList<TimeSeries>>>.empty();

  RxList<RxMap<String, RxList<TimeSeries>>> sliGraphs =
      RxList<RxMap<String, RxList<TimeSeries>>>.empty();

  RxList<RxMap<String, RxList<TimeSeries>>> sliAlertGraphs =
      RxList<RxMap<String, RxList<TimeSeries>>>.empty();

  bool showOldGraphs = false;
  static Map<int, double> convertListToMap(List list) {
    // converts API data of [epoch, value] to {epoch: value}
    return Map.fromIterable(list.reversed.where((e) => e[1] != null),
        key: (e) => e[0].toInt(), value: (e) => e[1].toDouble());
  }

  static Map<int, String> convertListToMapLogs(List list) {
    // converts API data of [epoch, logs] to {epoch: logs}
    return Map.fromIterable(list.where((e) => e[1] != null),
        key: (e) => e[0], value: (e) => e[1].toString());
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<TimeSeriesController>();
    super.onClose();
  }

  Future<void> getSingleTimeSeries(
    DateTime start,
    DateTime end,
    Sensor sensor,
    bool isAlert,
    String sliPid,
    String sliName,
    List<Functionality?> functions,
  ) async {
    try {
      RxMap<String, RxList<TimeSeries>> instanceSliMap = RxMap();
      if (sensor.isPulse() && sliPid != "") {
        //for sli functionalities
        RxList<TimeSeries> instanceSliList = RxList.empty(growable: true);

        if (!isAlert) {
          sliGraphs.add(instanceSliMap);
        } else {
          sliAlertGraphs.add(instanceSliMap);
        }
        for (Functionality? function in functions) {
          if (function == null) {
            continue;
          }
          final response = await http.get(Uri.parse(
              'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&PID=$sliPid&${function.key}&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
          if (response.statusCode == 200) {
            if (jsonDecode(response.body).length <= 0) {
              continue;
            }
            var body = jsonDecode(response.body)[0];

            String color = body['color'];
            String key = body['key'];

            if (body["values"] == null) {
              instanceSliList.add(new TimeSeries(
                  name: key,
                  color: color,
                  timeSeries: null,
                  key: function.key));
              continue;
            }

            if (body["values"][0][1] is String) {
              Map<int, String> logSeries = convertListToMapLogs(body['values']);
              instanceSliList.add(new LogSeries(
                  name: key, key: function.key, logSeries: logSeries));
              continue;
            }

            Map<int, double> timeSeries = convertListToMap(body['values']);
            instanceSliList.add(new TimeSeries(
                name: key,
                color: color,
                timeSeries: timeSeries,
                key: function.key));
          } else {
            EasyLoading.showError("Failed to retrieve data! Try again.",
                duration: Duration(seconds: 3), dismissOnTap: true);
          }
        }
      }
      // for non-sli functions
      RxList<TimeSeries> instanceList = RxList.empty(growable: true);
      if (!isAlert) {
        graphs.add(instanceList);
      } else {
        alertGraphs.add(instanceList);
      }

      instanceSliMap["Driver: " + sliName + " SLI: " + sliPid] = instanceList;
      final response = await http.get(Uri.parse(
          'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&PID=$sliPid&${functions[0]!.key}&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
      if (response.statusCode == 200) {
        if (jsonDecode(response.body).length <= 0) {
          return;
        }
        var body = jsonDecode(response.body)[0];

        String color = body['color'];
        String key = body['key'];
        if (body["values"] == null) {
          instanceList.add(new TimeSeries(
              name: key,
              color: color,
              timeSeries: null,
              key: functions[0]!.key));
          return;
        }
        if (body["values"][0][1] is String) {
          Map<int, String> logSeries = convertListToMapLogs(body['values']);
          instanceList.add(new LogSeries(
              name: key, key: functions[0]!.key, logSeries: logSeries));
          return;
        }
        Map<int, double> timeSeries = convertListToMap(body['values']);
        instanceList.add(new TimeSeries(
            name: key,
            color: color,
            timeSeries: timeSeries,
            key: functions[0]!.key));
      } else {
        // EasyLoading.showError("Failed to retrieve data! Try again.",
        //     duration: Duration(seconds: 3), dismissOnTap: true);
        instanceList.add(new TimeSeries(
            name: "ERROR", color: 'FFffffff', timeSeries: null, key: 'error'));
      }
      if (sliGraphs.length > 1 && !isAlert) {
        sliGraphs.removeRange(0, sliGraphs.length - 1);
      } else if (sliAlertGraphs.length > 1) {
        sliAlertGraphs.removeRange(0, sliAlertGraphs.length - 1);
      }
    } on SocketException catch (e) {
      EasyLoading.showError(
          'Network Error: please check your internet connection.');
    }
  }

  Future<void> getSliMultiSeries(RxList<TimeSeries> instanceList, bool isAlert,
      Sensor sensor, DateTime start, DateTime end) async {
    dynamic slil = (sensor as Pulse).slil; //left sli
    dynamic slir = (sensor).slir; //right sli
    RxMap<String, RxList<TimeSeries>> instanceSliMap = RxMap();

    if (!isAlert) {
      sliGraphs.add(instanceSliMap);
    } else {
      sliAlertGraphs.add(instanceSliMap);
    }

    for (dynamic sli in sensor.sli!) {
      String pid = sli["PID"].toString();
      dynamic sid = sli["SID"];
      String? name = sli["name"];

      if (sid == slil || sid == slir && (slil != 0 || slir != 0)) {
        RxList<TimeSeries> instanceSliList = RxList.empty(growable: true);
        instanceSliMap[(name != null ? "Driver: " + name.toString() : "") +
            " SLI: " +
            pid] = instanceSliList;
        int total = sli["plottable"].length;
        int count = 0;
        int starti = 0;
        if (total <= 0) {
          instanceSliList.add(new TimeSeries(
              name: "-", color: 'FFFFFF', timeSeries: null, key: '-'));
        }
        while (total > 0) {
          List<String> nonNullFunctions = List.empty(growable: true);
          late final sublist;
          if (total - starti >= intConcurrentCount) {
            sublist =
                sli["plottable"].sublist(starti, starti + intConcurrentCount);
          } else {
            sublist = sli["plottable"].sublist(starti, starti + total);
          }

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
                'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&$function&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
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

              String color = body['color'];
              String key = body['key'];

              if (body["values"] == null) {
                instanceSliList.add(new TimeSeries(
                    name: key,
                    color: color,
                    timeSeries: null,
                    key: nonNullFunctions[i]));
                continue;
              }
              if (body["values"][0][1] is String) {
                Map<int, String> logSeries =
                    convertListToMapLogs(body['values']);
                instanceSliList.add(new LogSeries(
                    name: key, key: nonNullFunctions[i], logSeries: logSeries));
                continue;
              }

              Map<int, double> timeSeries = convertListToMap(body['values']);
              instanceSliList.add(new TimeSeries(
                  name: key,
                  color: color,
                  timeSeries: timeSeries,
                  key: nonNullFunctions[i]));
            } else {
              instanceSliList.add(new TimeSeries(
                  name: "ERROR",
                  color: 'FFffffff',
                  timeSeries: null,
                  key: 'error'));
            }
          }
          starti += count;
        }
      }
    }
  }

  Future<void> getMultiSeries(
      RxList<TimeSeries> instanceList,
      DateTime start,
      DateTime end,
      List<Functionality?> functions,
      Sensor sensor,
      bool isAlert) async {
    //create a list of functions
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
      total -= intConcurrentCount;

      Iterable<Future<http.Response>> futureResponses =
          nonNullFunctions.map((Functionality function) {
        Future<http.Response> response = http.get(Uri.parse(
            'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${function.key}&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
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

          String color = body['color'];
          String key = body['key'];

          if (body["values"] == null) {
            instanceList.add(new TimeSeries(
                name: key,
                key: nonNullFunctions[i].key,
                color: color,
                timeSeries: null));
            continue;
          }
          if (body["values"][0][1] is String) {
            Map<int, String> logSeries = convertListToMapLogs(body['values']);
            instanceList.add(new LogSeries(
                name: key,
                key: nonNullFunctions[i].name,
                logSeries: logSeries));
            continue;
          }

          Map<int, double> timeSeries = convertListToMap(body['values']);
          instanceList.add(new TimeSeries(
              name: key,
              color: color,
              timeSeries: timeSeries,
              key: nonNullFunctions[i].key));
        } else {
          instanceList.add(new TimeSeries(
              name: "ERROR",
              color: 'FFffffff',
              timeSeries: null,
              key: 'error'));
        }
      }
      starti += count;
    }
  }

  Future<void> getMultiTimeSeries(
    DateTime start,
    DateTime end,
    List<Functionality?> functions,
    Sensor sensor,
    bool isAlert,
  ) async {
    try {
      RxList<TimeSeries> instanceList = RxList.empty(growable: true);

      if (!isAlert) {
        graphs.add(instanceList);
      } else {
        alertGraphs.add(instanceList);
      }

      //check if pulse
      if (sensor.isPulse()) {
        await getSliMultiSeries(instanceList, isAlert, sensor, start, end);
      }

      await getMultiSeries(
          instanceList, start, end, functions, sensor, isAlert);
      if (graphs.length > 1 && !isAlert) {
        graphs.removeRange(0, graphs.length - 1);
      } else if (alertGraphs.length > 1) {
        alertGraphs.removeRange(0, alertGraphs.length - 1);
      }
    } on SocketException catch (e) {
      EasyLoading.showError(
          'Network Error: please check your internet connection.',
          duration: Duration(seconds: 3),
          dismissOnTap: true);
      RxList<TimeSeries> instanceList = RxList.empty(growable: true);
      if (!isAlert) {
        graphs.add(instanceList);
      } else {
        alertGraphs.add(instanceList);
      }
      for (int i = 0; i < functions.length; i++) {
        instanceList.add(new TimeSeries(
            name: "ERROR", color: 'FFffffff', timeSeries: null, key: 'error'));
      }
    }
  }

  Future<void> getOldSliTimeSeries(DateTime start, DateTime end,
      List<Functionality?> functions, Sensor sensor, bool isAlert) async {
    RxMap<String, RxList<TimeSeries>> instanceOldSliMap = RxMap();

    dynamic slil = (sensor as Pulse).slil;
    dynamic slir = (sensor).slir;
    if (!isAlert) {
      oldSliGraphs.add(instanceOldSliMap);
    } else {
      oldSliAlertGraphs.add(instanceOldSliMap);
    }
    for (dynamic sli in sensor.sli!) {
      dynamic sid = sli["SID"];
      if (sid == slil || sid == slir && (slil != 0 || slir != 0)) {
        continue;
      }
      RxList<TimeSeries> instanceSliList = RxList.empty(growable: true);
      String pid = sli["PID"].toString();
      String name = sli["name"].toString();
      instanceOldSliMap["Driver: " + name + " SLI: " + pid] = instanceSliList;
      int total = sli["plottable"].length;
      int count = 0;
      int starti = 0;
      if (total <= 0) {
        instanceSliList.add(new TimeSeries(
            name: "-", color: 'FFFFFF', timeSeries: null, key: '-'));
      }
      while (total > 0) {
        List<String> nonNullFunctions = List.empty(growable: true);
        late final sublist;
        if (total - starti >= intConcurrentCount) {
          sublist =
              sli["plottable"].sublist(starti, starti + intConcurrentCount);
        } else {
          sublist = sli["plottable"].sublist(starti, starti + total);
        }

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
              'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&$function&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
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

            String color = body['color'];
            String key = body['key'];
            if (body["values"] == null) {
              instanceSliList.add(
                new TimeSeries(
                    name: key,
                    color: color,
                    timeSeries: null,
                    key: nonNullFunctions[i]),
              );
              continue;
            }
            if (body["values"][0][1] is String) {
              Map<int, String> logSeries = convertListToMapLogs(body['values']);
              instanceSliList.add(new LogSeries(
                  name: key, key: nonNullFunctions[i], logSeries: logSeries));
              continue;
            }
            Map<int, double> timeSeries = convertListToMap(body['values']);
            instanceSliList.add(new TimeSeries(
                name: key,
                color: color,
                timeSeries: timeSeries,
                key: nonNullFunctions[i]));
          } else {
            // EasyLoading.showError("Failed to retrieve data! Try again.",
            //     duration: Duration(seconds: 3),
            //     dismissOnTap: true); //Ask UI to reload
            // }
            instanceSliList.add(new TimeSeries(
                name: "ERROR",
                color: 'FFffffff',
                timeSeries: null,
                key: 'error'));
          }

          starti += count;
        }
      }
    }
  }

  int countNumberOfGraphs(List<Functionality?> functions) {
    int count = 0;
    for (Functionality? function in functions) {
      if (function == null) {
        continue;
      }
      if (function.value is List) {
        List<Functionality?> subFunc = function.value;
        List<Functionality?> nonNullFunctions =
            subFunc.where((e) => e != null).toList();

        count += nonNullFunctions.length;
      } else {
        count += 1;
      }
    }
    return count;
  }

  int countSliGraphs(Sensor sensor) {
    //List<int> sliCount = [];
    dynamic slil = (sensor as Pulse).slil;
    dynamic slir = (sensor).slir;
    int sliCount = 0;
    for (dynamic sli in sensor.sli!) {
      dynamic sid = sli["SID"];
      if (sid == slil || sid == slir && (slil != 0 || slir != 0)) {
        sliCount += (sli["plottable"] as List).length;
      }
    }
    return sliCount;
  }

  int countOldGraphs(Sensor sensor) {
    dynamic slil = (sensor as Pulse).slil;
    dynamic slir = (sensor).slir;
    int sliCount = 0;
    for (dynamic sli in sensor.sli!) {
      dynamic sid = sli["SID"];
      if (sid == slil || sid == slir && (slil != 0 || slir != 0)) {
      } else {
        sliCount += (sli["plottable"] as List).length;
      }
    }
    return sliCount;
  }
}
