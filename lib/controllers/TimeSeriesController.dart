import 'dart:convert';
import 'package:get/get.dart';

import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

class TimeSeriesController extends GetxController {
  TimeSeries? currentTimeSeries;
  AuthController authController = Get.find();
  RxList<TimeSeries> graphs = RxList<TimeSeries>.empty();

  static Map<int, double> convertListToMap(List list) {
    return Map.fromIterable(list.reversed.where((e) => e[1] != null),
        key: (e) => e[0].toInt(), value: (e) => e[1].toDouble());
  }

  Future<void> getTimeSeries(
      DateTime start, DateTime end, String key, Sensor sensor) async {
    graphs.clear();
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&$key&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
    // print(
    //     'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&$key&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}');
    // print(
    //     'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&$key&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}');
    print("key: $key");
    print("status code ${response.statusCode}");
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)[0];

      String color = body['color'];
      String key = body['key'];
      if (body["values"] == null) {
        return;
      }
      Map<int, double> timeSeries = convertListToMap(body['values']);
      graphs
          .add(new TimeSeries(key: key, color: color, timeSeries: timeSeries));

      return;
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  Future<void> getMultiTimeSeries(DateTime start, DateTime end,
      List<Functionality> functions, Sensor sensor) async {
    graphs.clear();
    for (Functionality function in functions) {
      print("key: ${function.key}");
      final response = await http.get(Uri.parse(
          'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${function.key}&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
      print("status code ${response.statusCode}");
      if (response.statusCode == 200) {
        if (jsonDecode(response.body).length <= 0) {
          continue;
        }
        var body = jsonDecode(response.body)[0];

        String color = body['color'];
        String key = body['key'];
        if (body["values"] == null) {
          continue;
        }
        Map<int, double> timeSeries = convertListToMap(body['values']);
        graphs.add(
            new TimeSeries(key: key, color: color, timeSeries: timeSeries));
      } else {
        throw Exception("Failed to retrieve data"); //Ask UI to reload
      }
    }
  }
}
