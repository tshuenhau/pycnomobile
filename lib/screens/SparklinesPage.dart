import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SparklinesBuilder.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/widgets/SparklineListTile.dart';

class SparklinesPage extends StatelessWidget {
  SparklinesPage({Key? key, required this.sensor}) : super(key: key);
  Sensor sensor;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: buildSparklines(sensor: sensor, context: context),
    );
  }
}
