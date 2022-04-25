import 'package:flutter/material.dart';

class Functionality<T> {
  String name;
  String? unit;
  Color? color;
  IconData? icon;
  T? value;
  String key;

  Functionality({
    required this.name,
    required this.key,
    required this.unit,
    required this.color,
    required this.icon,
    required this.value,
  });

  @override
  String toString() {
    return 'name: $name, value: $value';
  }
}
