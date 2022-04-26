import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SparklinesBuilder.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/widgets/SparklineListTile.dart';
import 'package:get/get.dart';

class SparklinesPage extends StatelessWidget {
  SparklinesPage({Key? key, required this.sensor}) : super(key: key);
  Sensor sensor;

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.count(
          primary: false,
          childAspectRatio: (9 / 6),
          padding:
              EdgeInsets.all(MediaQuery.of(context).size.width * 3.5 / 100),
          crossAxisSpacing: MediaQuery.of(context).size.width * 1 / 100,
          mainAxisSpacing: MediaQuery.of(context).size.width * 1 / 100,
          crossAxisCount: 2,
          children: buildSparklines(sensor: sensor, context: context),
        ));
  }
}
