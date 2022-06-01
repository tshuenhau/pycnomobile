import "package:Sensr/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Uv extends Functionality<double?> {
  Uv(double? value)
      : super(
            name: "UV radiation",
            key: "UV",
            unit: "mW/cm2",
            color: Colors.orange,
            icon: FontAwesomeIcons.radiationAlt,
            value: value);
}
