import "package:pycnomobile/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Rainh extends Functionality<double?> {
  Rainh(double? value)
      : super(
            name: "Rainfall intensity",
            unit: "mm/h",
            color: Colors.blue,
            value: value,
            icon: FontAwesomeIcons.cloudShowersHeavy);
}
