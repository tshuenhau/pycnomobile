import "package:pycnomobile/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';

class Bat extends Functionality<double?> {
  Bat(double? value)
      : super(
            name: "Battery",
            unit: "V",
            color: Colors.green,
            value: value,
            icon: Icons.battery_charging_full);
}
