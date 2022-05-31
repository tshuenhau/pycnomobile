import "package:Sensr/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';

class Lx1 extends Functionality<double?> {
  Lx1(double? value)
      : super(
            name: "Luminosity",
            key: "LX1",
            unit: "Lux",
            color: Colors.yellow,
            icon: Icons.wb_sunny,
            value: value);
}
