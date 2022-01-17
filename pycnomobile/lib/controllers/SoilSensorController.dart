import 'dart:convert';

import 'package:get/get.dart';
import 'package:pycnomobile/model/soilsensor.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/logic/Commons.dart';

class SoilSensorController extends GetxController {
  getSoilSensorInfo(SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/no/${sensor.uid}.json?TK=${token}'));

    if (response.statusCode == 200) {
      sensor.setLatestInfo(jsonDecode(response.body));
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  getBatteryTimeSeries(DateTime start, DateTime end, SoilSensor sensor) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=${sensor.uid}&BAT&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  getOrderOfPacketsTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&NS&start=${start}&end=${end}'));
    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  getTemperatureTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&TEMP&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  getHumidityTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&HUM&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  getSunlightTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&LX1&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  getSolarRadiationTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&LW1&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  getVersionTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&VE&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  getUnitLogTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&TXT&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  getRainfallTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&RAINH&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  getSensorToSensorFreqTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&LFREQ&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }

  getSignalStrengthTimeSeries(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/1?TK=${token}&UID=M05D53733415251045317&RSSI&start=${start}&end=${end}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }
}
