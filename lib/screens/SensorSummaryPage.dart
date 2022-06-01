import 'package:flutter/material.dart';
import 'package:Sensr/builders/SummaryCardBuilder.dart';
import 'package:Sensr/model/sensors/Sensor.dart';

class SensorSummaryPage extends StatelessWidget {
  const SensorSummaryPage({Key? key, required this.sensor}) : super(key: key);

  final Sensor sensor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: buildSummaryCards(sensor: sensor, context: context),
      ),
    );
  }
}
