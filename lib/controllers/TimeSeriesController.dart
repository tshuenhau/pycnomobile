import 'dart:convert';
import 'package:get/get.dart';
import 'package:async/async.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

class TimeSeriesController extends GetxController {
  TimeSeries? currentTimeSeries;
  AuthController authController = Get.find();
  RxList<RxList<TimeSeries?>> graphs = RxList<RxList<TimeSeries?>>.empty();
  Rx<int> howManyGraphs = 0.obs;
  CancelableOperation? cancelableTimeSeries;

  static Map<int, double> convertListToMap(List list) {
    return Map.fromIterable(list.reversed.where((e) => e[1] != null),
        key: (e) => e[0].toInt(), value: (e) => e[1].toDouble());
  }

  // Future<void> getTimeSeries(
  //     DateTime start, DateTime end, String key, Sensor sensor) async {
  //   graphs.clear();
  //   final response = await http.get(Uri.parse(
  //       'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&$key&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
  //   // print(
  //   //     'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&$key&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}');
  //   // print(
  //   //     'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&$key&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}');
  //   print("key: $key");
  //   print("status code ${response.statusCode}");
  //   if (response.statusCode == 200) {
  //     var body = jsonDecode(response.body)[0];

  //     String color = body['color'];
  //     String key = body['key'];
  //     if (body["values"] == null) {
  //       return;
  //     }
  //     Map<int, double> timeSeries = convertListToMap(body['values']);
  //     graphs
  //         .add(new TimeSeries(key: key, color: color, timeSeries: timeSeries));

  //     return;
  //   } else {
  //     throw Exception("Failed to retrieve data"); //Ask UI to reload
  //   }
  // }

  Future<void> getMultiTimeSeries(DateTime start, DateTime end,
      List<Functionality?> functions, Sensor sensor) async {
    RxList<TimeSeries?> instanceList = RxList.empty(growable: true);
    graphs.add(instanceList);

    for (Functionality? function in functions) {
      if (function != null) {
        if (function.value is List) {
          //multi value
          List func = function.value;

          for (Functionality? subfunc in func) {
            print(subfunc);
            if (subfunc != null) {
              final response = await http.get(Uri.parse(
                  'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${subfunc.key}&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
              // print(
              //     'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${subfunc.key}&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}');
              if (response.statusCode == 200) {
                if (jsonDecode(response.body).length <= 0) {
                  continue;
                }
                var body = jsonDecode(response.body)[0];

                String color = body['color'];
                String key = body['key'];
                if (body["values"] == null) {
                  instanceList.add(null);
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
          print(function.key);
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
              instanceList.add(null);
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
    print(graphs.length);
    if (graphs.length > 1) {
      graphs.removeRange(0, graphs.length - 1);
    }
    print(graphs.last);
  }

  // Future<void> createCancelableTimeSeries(DateTime start, DateTime end,
  //     List<Functionality?> functions, Sensor sensor) async {
  //   cancelableTimeSeries?.cancel();
  //   cancelableTimeSeries = CancelableOperation.fromFuture(
  //       getMultiTimeSeries(start, end, functions, sensor), onCancel: () {
  //     print("Operation cancelled");
  //     graphs.clear();
  //     print(graphs);
  //   });
  // }

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
}
