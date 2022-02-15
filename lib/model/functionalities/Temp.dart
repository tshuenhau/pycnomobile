import "package:pycnomobile/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';

class Temp extends Functionality<double?> {
  Temp(double? value)
      : super(
            name: "Temperature",
            key: "TEMP",
            unit: "ºC",
            color: Colors.red,
            value: value,
            icon: Icons.thermostat);
}
