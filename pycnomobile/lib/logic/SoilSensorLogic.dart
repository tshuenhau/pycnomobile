import 'dart:convert';

import 'package:pycnomobile/model/soilsensor.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/logic/Commons.dart';

class SoilSensorLogic {
  static getSoilSensorInfo(SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/no/${sensor.uid}.json?TK=${token}'));

    if (response.statusCode == 200) {
      sensor.setLatestInfo(jsonDecode(response.body));
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static getBatteryTimeSeries(
      DateTime start, DateTime end, SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=${sensor.uid}&BAT&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
      jsonDecode(response.body);
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static getOrderOfPacketsTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&NS&start=${start}&end=${end}'));
    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static getTemperatureTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&TEMP&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static getHumidityTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&HUM&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static getSunlightTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&LX1&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static getSolarRadiationTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&LW1&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static getVersionTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&VE&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static getUnitLogTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&TXT&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static getRainfallTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&RAINH&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static getSensorToSensorFreqTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&LFREQ&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  static getSignalStrengthTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&RSSI&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }
}
