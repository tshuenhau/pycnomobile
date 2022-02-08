import 'dart:convert';
import 'package:get/get.dart';

import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/AuthController.dart';

class TimeSeriesController extends GetxController {
  TimeSeries? currentTimeSeries;
  AuthController authController = Get.find();

  static Map<int, double> convertListToMap(List list) {
    return Map.fromIterable(list.reversed.where((e) => e[1] != null),
        key: (e) => e[0].toInt(), value: (e) => e[1].toDouble());
  }

  Future<void> getTimeSeries(
      DateTime start, DateTime end, String key, Sensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&$key&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
    // print(
    //     'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&$key&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}');
    print(
        'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&$key&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}');
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)[0];

      String color = body['color'];
      String key = body['key'];
      if (body["values"] == null) {
        currentTimeSeries = null;
        return;
      }
      Map<int, double> timeSeries = convertListToMap(body['values']);
      currentTimeSeries =
          new TimeSeries(key: key, color: color, timeSeries: timeSeries);

      return;
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }
}
