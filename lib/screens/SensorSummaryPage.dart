import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SummaryCardBuilder.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';

class SensorSummaryPage extends StatelessWidget {
  const SensorSummaryPage({
    Key? key,
    required this.sensor,
  }) : super(key: key);

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
