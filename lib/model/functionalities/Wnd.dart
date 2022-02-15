import "package:pycnomobile/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Wnd extends Functionality<double?> {
  Wnd(double? value)
      : super(
            name: "Wind Speed",
            keys: ["WND"],
            unit: "km/h",
            color: Colors.green,
            value: value,
            icon: FontAwesomeIcons.wind);
}
