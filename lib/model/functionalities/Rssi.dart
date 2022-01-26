import "package:pycnomobile/model/functionalities/Functionality.dart";
import 'package:flutter/material.dart';

class Rssi extends Functionality<double?> {
  Rssi(double? value)
      : super(
            name: "Signal Strength",
            key: "RSSI",
            unit: "dBm",
            color: Colors.grey,
            value: value,
            icon: Icons.signal_cellular_alt);
}
