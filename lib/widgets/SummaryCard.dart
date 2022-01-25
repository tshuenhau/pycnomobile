import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SensorGrapshBuilder.dart';
import 'package:pycnomobile/model/Sensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

class SummaryCard extends StatelessWidget {
  final Sensor sensor;
  final Widget child;
  final List<Functionality> functions;
  const SummaryCard(
      {Key? key,
      required this.child,
      required this.sensor,
      required this.functions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: () => {buildSensorGraphs(context, sensor, functions)},
            child: child));
  }
}
