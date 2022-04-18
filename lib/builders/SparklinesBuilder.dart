import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/controllers/SensorInfoController.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/widgets/SparklineListTile.dart';

// Future<void> initSparklines({required Sensor sensor}) async {
//   SensorInfoController controller = Get.put(SensorInfoController());
//   await controller.getTimeSeriesForSparklines(sensor);
// }

List<Widget> buildSparklines(
    {required Sensor sensor, required BuildContext context}) {
  print("Building sparklines...");
  SensorInfoController controller = Get.put(SensorInfoController());
  List<Widget> sparkLines = [];

  print("Sparklines length: " + controller.sparkLines.length.toString());

  controller.sparkLines.forEach((e) {
    print("1");
    sparkLines.add(SparklineListTile());
  });
  return sparkLines;
}
