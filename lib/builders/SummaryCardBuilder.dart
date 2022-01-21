import 'package:flutter/material.dart';
import 'package:pycnomobile/model/Sensor.dart';
import 'package:pycnomobile/widgets/BasicSummaryCard.dart';

List<Widget> buildSummaryCards(Sensor sensor) {
  //! Logic to build summary cards here
  return [
    BasicSummaryCard(
        icon: Icons.thermostat, color: Colors.red, value: 17.55, unit: "°C"),
    BasicSummaryCard(
        icon: Icons.thermostat, color: Colors.red, value: 17.55, unit: "°C"),
    BasicSummaryCard(
        icon: Icons.thermostat, color: Colors.red, value: 17.55, unit: "°C"),
  ];
}
