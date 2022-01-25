import "package:pycnomobile/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Hum extends Functionality<double?> {
  Hum(double? value)
      : super(
            name: "Humidity",
            unit: "RH%",
            color: Colors.blue,
            value: value,
            icon: FontAwesomeIcons.tint);
}
