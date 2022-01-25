import "package:pycnomobile/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';

class St135 extends Functionality<List<Functionality>> {
  St135(List<Functionality> value)
      : super(
          name: "Soil temperature",
          unit: "ºC",
          color: null,
          icon: null,
          value: value,
        );
}
