import "package:pycnomobile/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Lw1 extends Functionality<double?> {
  Lw1(double? value)
      : super(
            name: "Solar Radiation",
            key: "LW1",
            unit: "W/m2",
            color: Colors.yellow,
            value: value,
            icon: FontAwesomeIcons.radiationAlt);
}
