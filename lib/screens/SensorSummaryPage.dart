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
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 95 / 100,
          height: MediaQuery.of(context).size.height,
          child: buildSummaryCards(sensor: sensor, context: context),
        ),
      ),
    );
  }
}
