import 'package:flutter/material.dart';

class Functionality<T> {
  String name;
  String unit;
  Color? color;
  IconData? icon;
  T value;
  List<String>? multiKeys;

  Functionality(
      {required this.name,
      required this.unit,
      required this.color,
      required this.icon,
      required this.value});
}
