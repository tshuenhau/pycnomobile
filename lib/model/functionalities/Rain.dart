import "package:Sensr/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Rain extends Functionality<double?> {
  Rain(double? value)
      : super(
            name: "Rainfall",
            key: "RAIN",
            unit: "mm",
            color: Colors.grey,
            value: value,
            icon: FontAwesomeIcons.cloudShowersHeavy);
}
