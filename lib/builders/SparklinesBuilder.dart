import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/controllers/SensorInfoController.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/widgets/SparklineListTile.dart';
import 'package:pycnomobile/model/TimeSeries.dart';

// Future<void> initSparklines({required Sensor sensor}) async {
//   SensorInfoController controller = Get.put(SensorInfoController());
//   await controller.getTimeSeriesForSparklines(sensor);
// }

List<Widget> buildSparklines(
    {required Sensor sensor, required BuildContext context}) {
  print("Building sparklines...");
  SensorInfoController controller = Get.put(SensorInfoController());
  List<Widget> sparkLines = [];

  // print("Sparklines length: " + controller.sparkLines.length.toString());

  /*
    Sparklines format: Map<String, List<TimeSeries>> 
                              |            |
                             SLI's PID  TimeSeries for each functionality in SLI
  */
  controller.sparkLines.forEach((key, value) {
    value.forEach((TimeSeries e) {
      print(e.getTimeSeries);
      if (e.getTimeSeries == null) {
        //fake data, to remove
        return;
      }
      sparkLines.add(SparklineListTile(
          sli: key,
          name: e.getKey,
          data: controller.convertTimeSeriestoList(e.getTimeSeries!)));
    });
  });
  print("SPARKLINES: " + sparkLines.toString());
  return sparkLines;
}
