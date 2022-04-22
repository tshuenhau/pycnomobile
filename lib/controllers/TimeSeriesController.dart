import 'dart:convert';
import 'package:get/get.dart';
import 'dart:async';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/sensors/Pulse.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

class TimeSeriesController extends GetxController {
  TimeSeries? currentTimeSeries;
  AuthController authController = Get.find();
  RxList<RxList<TimeSeries>> graphs = RxList<RxList<TimeSeries>>.empty();
  RxList<RxList<TimeSeries>> alertGraphs = RxList<RxList<TimeSeries>>.empty();

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
    return Map.fromIterable(list.reversed.where((e) => e[1] != null),
        key: (e) => e[0].toInt(), value: (e) => e[1].toDouble());
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

  Future<void> getMultiTimeSeries(DateTime start, DateTime end,
      List<Functionality?> functions, Sensor sensor, bool isAlert) async {
    RxList<TimeSeries> instanceList = RxList.empty(growable: true);
    RxMap<String, RxList<TimeSeries>> instanceSliMap = RxMap();
    if (!isAlert) {
      graphs.add(instanceList);
    } else {
      alertGraphs.add(instanceList);
    }

    //check if pulse
    if (sensor.isPulse()) {
      dynamic slil = (sensor as Pulse).slil;
      dynamic slir = (sensor).slir;

      if (!isAlert) {
        sliGraphs.add(instanceSliMap);
      } else {
        sliAlertGraphs.add(instanceSliMap);
      }

      for (dynamic sli in sensor.sli!) {
        String pid = sli["PID"].toString();
        dynamic sid = sli["SID"];
        print("SID " + sid.toString());

        if (sid == slil || sid == slir && (slil != 0 || slir != 0)) {
          RxList<TimeSeries> instanceSliList = RxList.empty(growable: true);
          instanceSliMap[pid] = instanceSliList;
          for (String functionality in sli["plottable"]) {
            final response = await http.get(Uri.parse(
                'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&PID=${sli["PID"]}&$functionality&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
            if (response.statusCode == 200) {
              if (jsonDecode(response.body).length <= 0) {
                continue;
              }
              var body = jsonDecode(response.body)[0];

              String color = body['color'];
              String key = body['key'];
              if (body["values"] == null) {
                instanceSliList.add(
                    new TimeSeries(key: key, color: color, timeSeries: null));
                continue;
              }
              Map<int, double> timeSeries = convertListToMap(body['values']);
              instanceSliList.add(new TimeSeries(
                  key: key, color: color, timeSeries: timeSeries));
            } else {
              throw Exception("Failed to retrieve data"); //Ask UI to reload
            }
          }
        }
      }
      if (sliGraphs.length > 1 && !isAlert) {
        sliGraphs.removeRange(0, sliGraphs.length - 1);
      } else if (sliAlertGraphs.length > 1) {
        sliAlertGraphs.removeRange(0, sliAlertGraphs.length - 1);
      }
    }

    for (Functionality? function in functions) {
      if (function != null) {
        if (function.value is List) {
          //multi value
          List func = function.value;

          for (Functionality? subfunc in func) {
            if (subfunc != null) {
              final response = await http.get(Uri.parse(
                  'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${subfunc.key}&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
              if (response.statusCode == 200) {
                if (jsonDecode(response.body).length <= 0) {
                  continue;
                }
                var body = jsonDecode(response.body)[0];

                String color = body['color'];
                String key = body['key'];
                if (body["values"] == null) {
                  instanceList.add(
                      new TimeSeries(key: key, color: color, timeSeries: null));
                  continue;
                }
                Map<int, double> timeSeries = convertListToMap(body['values']);
                instanceList.add(new TimeSeries(
                    key: key, color: color, timeSeries: timeSeries));
              } else {
                throw Exception("Failed to retrieve data"); //Ask UI to reload
              }
            }
          }
        } else {
          final response = await http.get(Uri.parse(
              'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${function.key}&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));

          if (response.statusCode == 200) {
            if (jsonDecode(response.body).length <= 0) {
              continue;
            }
            var body = jsonDecode(response.body)[0];

            String color = body['color'];
            String key = body['key'];
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
    if (graphs.length > 1 && !isAlert) {
      graphs.removeRange(0, graphs.length - 1);
    } else if (alertGraphs.length > 1) {
      alertGraphs.removeRange(0, alertGraphs.length - 1);
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
      instanceOldSliMap[pid] = instanceSliList;
      for (String functionality in sli["plottable"]) {
        final response = await http.get(Uri.parse(
            'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&PID=${sli["PID"]}&$functionality&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
        if (response.statusCode == 200) {
          if (jsonDecode(response.body).length <= 0) {
            continue;
          }
          var body = jsonDecode(response.body)[0];

          String color = body['color'];
          String key = body['key'];
          if (body["values"] == null) {
            instanceSliList
                .add(new TimeSeries(key: key, color: color, timeSeries: null));
            continue;
          }
          Map<int, double> timeSeries = convertListToMap(body['values']);
          instanceSliList.add(
              new TimeSeries(key: key, color: color, timeSeries: timeSeries));
        } else {
          throw Exception("Failed to retrieve data");
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
    print("SLI COUNT " + sliCount.toString());
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
    print("COUNT " + sliCount.toString());
    return sliCount;
  }
}
