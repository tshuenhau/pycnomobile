import "package:Sensr/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GenericFunctionality<T> extends Functionality<T> {
  GenericFunctionality(
    String name,
    String unit,
    String key,
    T value,
  ) : super(
            name: name,
            unit: unit,
            key: key,
            color: Colors.black,
            value: value,
            icon: null);
}
