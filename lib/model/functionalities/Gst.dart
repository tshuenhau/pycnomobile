import "package:pycnomobile/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Gst extends Functionality<double?> {
  Gst(double? value)
      : super(
            name: "Gust Speed",
            unit: "m/s",
            key: "GST",
            color: Colors.green,
            value: value,
            icon: FontAwesomeIcons.fan);
}
