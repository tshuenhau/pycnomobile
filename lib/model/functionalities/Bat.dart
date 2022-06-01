import "package:Sensr/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';

class Bat extends Functionality {
  Bat(double? value)
      : super(
            name: "Battery",
            key: 'BAT',
            unit: "V",
            color: Colors.green,
            value: value,
            icon: Icons.battery_charging_full);
}
