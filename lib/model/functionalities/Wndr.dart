import "package:Sensr/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Wndr extends Functionality<double?> {
  Wndr(double? value)
      : super(
            name: "Wind Direction",
            key: "WNDR",
            unit: "°",
            color: Colors.green,
            value: value,
            icon: FontAwesomeIcons.compass);
}
