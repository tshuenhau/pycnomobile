import 'package:flutter/material.dart';
import "package:pycnomobile/model/functionalities/Functionality.dart";

class S123456t extends Functionality<List<Functionality>> {
  S123456t(List<Functionality> value)
      : super(
            name: "Soil moisture",
            unit: "mm",
            color: null,
            value: value,
            icon: null);
}
