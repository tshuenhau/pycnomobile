import 'dart:convert';
import 'package:get/get.dart';

import 'package:pycnomobile/model/Sensor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pycnomobile/logic/Commons.dart';
import 'package:pycnomobile/model/TimeSeries.dart';

class TimeSeriesController extends GetxController {
  TimeSeries? currentTimeSeries;

  static Map<int, double> convertListToMap(List list) {
    return Map.fromIterable(list.reversed.where((e) => e[1] != null),
        key: (e) => e[0].toInt(), value: (e) => e[1].toDouble());
  }

  // static Future<TimeSeries<double>> getBatteryTimeSeries(
  //     DateTime start, DateTime end, SoilSensor sensor) async {
  //   final response = await http.get(Uri.parse(
  //       'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&BAT&start=$start&end=$end'));

  //   if (response.statusCode == 200) {
  //     var body = jsonDecode(response.body)[0];
  //     String color = body['color'];
  //     String key = body['key'];
  //     Map<DateTime, double> timeSeries =
  //         convertListToMap<double>(body['values']);
  //     return new TimeSeries<double>(
  //         key: key, color: color, timeSeries: timeSeries);
  //   } else {
  //     throw Exception("Failed to retrieve data"); //Ask UI to reload
  //   }
  // }

  // static Future<TimeSeries<double>> getTemperatureTimeSeries(
  //     DateTime start, DateTime end, SoilSensor sensor) async {
  //   final response = await http.get(Uri.parse(
  //       'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&TEMP&start=$start&end=$end'));

  //   if (response.statusCode == 200) {
  //     var body = jsonDecode(response.body)[0];
  //     String color = body['color'];
  //     String key = body['key'];
  //     Map<DateTime, double> timeSeries =
  //         convertListToMap<double>(body['values']);
  //     return new TimeSeries<double>(
  //         key: key, color: color, timeSeries: timeSeries);
  //   } else {
  //     throw Exception("Failed to retrieve data"); //Ask UI to reload
  //   }
  // }

  // static Future<TimeSeries<double>> getHumidityTimeSeries(
  //     DateTime start, DateTime end, SoilSensor sensor) async {
  //   final response = await http.get(Uri.parse(
  //       'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&HUM&start=$start&end=$end'));

  //   if (response.statusCode == 200) {
  //     var body = jsonDecode(response.body)[0];
  //     String color = body['color'];
  //     String key = body['key'];
  //     Map<DateTime, double> timeSeries =
  //         convertListToMap<double>(body['values']);
  //     return new TimeSeries<double>(
  //         key: key, color: color, timeSeries: timeSeries);
  //   } else {
  //     throw Exception("Failed to retrieve data"); //Ask UI to reload
  //   }
  // }

  // static Future<TimeSeries<double>> getSunlightTimeSeries(
  //     DateTime start, DateTime end, SoilSensor sensor) async {
  //   final response = await http.get(Uri.parse(
  //       'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&LX1&start=$start&end=$end'));

  //   if (response.statusCode == 200) {
  //     var body = jsonDecode(response.body)[0];
  //     String color = body['color'];
  //     String key = body['key'];
  //     Map<DateTime, double> timeSeries =
  //         convertListToMap<double>(body['values']);
  //     return new TimeSeries<double>(
  //         key: key, color: color, timeSeries: timeSeries);
  //   } else {
  //     throw Exception("Failed to retrieve data"); //Ask UI to reload
  //   }
  // }

  // static Future<TimeSeries<double>> getSolarRadiationTimeSeries(
  //     DateTime start, DateTime end, SoilSensor sensor) async {
  //   final response = await http.get(Uri.parse(
  //       'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&LW1&start=$start&end=$end'));

  //   if (response.statusCode == 200) {
  //     var body = jsonDecode(response.body)[0];
  //     String color = body['color'];
  //     String key = body['key'];
  //     Map<DateTime, double> timeSeries =
  //         convertListToMap<double>(body['values']);
  //     return new TimeSeries<double>(
  //         key: key, color: color, timeSeries: timeSeries);
  //   } else {
  //     throw Exception("Failed to retrieve data"); //Ask UI to reload
  //   }
  // }

  // static Future<TimeSeries<double>> getRainfallTimeSeries(
  //     DateTime start, DateTime end, SoilSensor sensor) async {
  //   final response = await http.get(Uri.parse(
  //       'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&RAINH&start=$start&end=$end'));

  //   if (response.statusCode == 200) {
  //     var body = jsonDecode(response.body)[0];
  //     String color = body['color'];
  //     String key = body['key'];
  //     Map<DateTime, double> timeSeries =
  //         convertListToMap<double>(body['values']);
  //     return new TimeSeries<double>(
  //         key: key, color: color, timeSeries: timeSeries);
  //   } else {
  //     throw Exception("Failed to retrieve data"); //Ask UI to reload
  //   }
  // }

  // static Future<TimeSeries<double>> getSignalStrengthTimeSeries(
  //     DateTime start, DateTime end, SoilSensor sensor) async {
  //   final response = await http.get(Uri.parse(
  //       'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&RSSI&start=$start&end=$end'));

  //   if (response.statusCode == 200) {
  //     var body = jsonDecode(response.body)[0];
  //     String color = body['color'];
  //     String key = body['key'];
  //     Map<DateTime, double> timeSeries =
  //         convertListToMap<double>(body['values']);
  //     return new TimeSeries<double>(
  //         key: key, color: color, timeSeries: timeSeries);
  //   } else {
  //     throw Exception("Failed to retrieve data"); //Ask UI to reload
  //   }
  // }

  Future<void> getTimeSeries(
      DateTime start, DateTime end, String key, Sensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&$key&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
    print(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&$key&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}');
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
