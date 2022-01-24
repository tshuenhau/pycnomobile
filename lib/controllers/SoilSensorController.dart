import 'dart:convert';
import 'package:get/get.dart';

import 'package:pycnomobile/model/SoilSensor.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/logic/Commons.dart';
import 'package:pycnomobile/model/TimeSeries.dart';

class SoilSensorController extends GetxController {
  static Map<String, String> functionality = {
    "temp": "TEMP",
    "hum": "HUM",
    "lx1": "LX1",
    "lw1": "LW1",
    "rainh": "RAINH",
    "s1t": "S1T",
    "s2t": "S2T",
    "s3t": "S3T",
    "s4t": "S4T",
    "s5t": "S5T",
    "s6t": "S6T",
    "st1": "ST1",
    "st3": "ST3",
    "st5": "ST5",
    "bat": "BAT",
    "rssi": "RSSI"
  };

  static Map<DateTime, T> convertListToMap<T>(List list) {
    return Map.fromIterable(list,
        key: (e) => DateTime.fromMillisecondsSinceEpoch(e[0]),
        value: (e) => e[1]);
  }

  static Future<TimeSeries<double>> getBatteryTimeSeries(
      DateTime start, DateTime end, SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&BAT&start=$start&end=$end'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)[0];
      String color = body['color'];
      String key = body['key'];
      Map<DateTime, double> timeSeries =
          convertListToMap<double>(body['values']);
      return new TimeSeries<double>(
          key: key, color: color, timeSeries: timeSeries);
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static Future<TimeSeries<double>> getTemperatureTimeSeries(
      DateTime start, DateTime end, SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&TEMP&start=$start&end=$end'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)[0];
      String color = body['color'];
      String key = body['key'];
      Map<DateTime, double> timeSeries =
          convertListToMap<double>(body['values']);
      return new TimeSeries<double>(
          key: key, color: color, timeSeries: timeSeries);
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static Future<TimeSeries<double>> getHumidityTimeSeries(
      DateTime start, DateTime end, SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&HUM&start=$start&end=$end'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)[0];
      String color = body['color'];
      String key = body['key'];
      Map<DateTime, double> timeSeries =
          convertListToMap<double>(body['values']);
      return new TimeSeries<double>(
          key: key, color: color, timeSeries: timeSeries);
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static Future<TimeSeries<double>> getSunlightTimeSeries(
      DateTime start, DateTime end, SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&LX1&start=$start&end=$end'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)[0];
      String color = body['color'];
      String key = body['key'];
      Map<DateTime, double> timeSeries =
          convertListToMap<double>(body['values']);
      return new TimeSeries<double>(
          key: key, color: color, timeSeries: timeSeries);
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static Future<TimeSeries<double>> getSolarRadiationTimeSeries(
      DateTime start, DateTime end, SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&LW1&start=$start&end=$end'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)[0];
      String color = body['color'];
      String key = body['key'];
      Map<DateTime, double> timeSeries =
          convertListToMap<double>(body['values']);
      return new TimeSeries<double>(
          key: key, color: color, timeSeries: timeSeries);
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static Future<TimeSeries<double>> getRainfallTimeSeries(
      DateTime start, DateTime end, SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&RAINH&start=$start&end=$end'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)[0];
      String color = body['color'];
      String key = body['key'];
      Map<DateTime, double> timeSeries =
          convertListToMap<double>(body['values']);
      return new TimeSeries<double>(
          key: key, color: color, timeSeries: timeSeries);
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static Future<TimeSeries<double>> getSignalStrengthTimeSeries(
      DateTime start, DateTime end, SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&RSSI&start=$start&end=$end'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)[0];
      String color = body['color'];
      String key = body['key'];
      Map<DateTime, double> timeSeries =
          convertListToMap<double>(body['values']);
      return new TimeSeries<double>(
          key: key, color: color, timeSeries: timeSeries);
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static Future<TimeSeries<T>?> getSoilSensorTimeSeries<T>(
      DateTime start, DateTime end, String key, SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=$token&UID=${sensor.uid}&$key&start=$start&end=$end'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)[0];
      String color = body['color'];
      String key = body['key'];
      if (body["values"] == null) {
        return null;
      }
      Map<DateTime, T> timeSeries = convertListToMap<T>(body['values']);
      return new TimeSeries<T>(key: key, color: color, timeSeries: timeSeries);
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }
}
