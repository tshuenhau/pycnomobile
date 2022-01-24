import 'package:flutter/material.dart';
import 'package:pycnomobile/model/Sensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/widgets/BasicSummaryCard.dart';

List<Widget> buildSummaryCards(Sensor sensor) {
  //! Logic to build summary cards here
  List<Functionality> functionalities = sensor.functionalities;
  return [
    BasicSummaryCard(
        icon: Icons.thermostat, color: Colors.red, value: 17.55, unit: "°C"),
    BasicSummaryCard(
        icon: Icons.thermostat, color: Colors.red, value: 17.55, unit: "°C"),
    BasicSummaryCard(
        icon: Icons.thermostat, color: Colors.red, value: 17.55, unit: "°C"),
  ];
}
