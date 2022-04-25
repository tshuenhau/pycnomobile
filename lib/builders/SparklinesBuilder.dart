import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/controllers/SensorInfoController.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/widgets/SparklineCard.dart';
import 'package:pycnomobile/widgets/SparklineListTile.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

// Future<void> initSparklines({required Sensor sensor}) async {
//   SensorInfoController controller = Get.put(SensorInfoController());
//   await controller.getTimeSeriesForSparklines(sensor);
// }

List<Widget> buildSparklines(
    {required Sensor sensor, required BuildContext context}) {
  print("Building sparklines...");
  SensorInfoController controller = Get.put(SensorInfoController());
  List<Widget> sparkLines = [];

  /*
    Sparklines format: Map<String, List<TimeSeries>>
                              |            |
                             SLI's PID  TimeSeries for each functionality in SLI
  */
  controller.sparkLines.forEach((key, value) {
    value.forEach((TimeSeries e) {
      if (e.getTimeSeries == null) {
        return;
      }
      sparkLines.add(SparklineCard(
          sensor: sensor,
          function: new Functionality(
              name: e.getName,
              key: e.getKey,
              value: null,
              color: null,
              icon: null,
              unit: null),
          sli: key,
          name: e.getName,
          data: controller.convertTimeSeriestoList(e.getTimeSeries!)));
    });
  });

  controller.nonSliSparklines.forEach((key, value) {
    value.forEach((TimeSeries e) {
      if (e.getTimeSeries == null) {
        return;
      }
      sparkLines.add(SparklineCard(
          sensor: sensor,
          function: new Functionality(
              name: e.getName,
              key: e.getKey,
              value: null,
              color: null,
              icon: null,
              unit: null),
          sli: controller.nonSliSparklines.keys.elementAt(0),
          name: e.getKey,
          data: controller.convertTimeSeriestoList(e.getTimeSeries!)));
    });
  });
  return sparkLines;
}
