import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/controllers/SensorInfoController.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/widgets/(OLD)SparklineCard.dart';
import 'package:pycnomobile/widgets/SparklineCard.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/model/sensors/Pulse.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

// Future<void> initSparklines({required Sensor sensor}) async {
//   SensorInfoController controller = Get.put(SensorInfoController());
//   await controller.getTimeSeriesForSparklines(sensor);
// }

List<Widget> buildSparklinesV2(
    {required Sensor sensor, required BuildContext context}) {
  print("build sparklines v2");

  List<Widget> cards = [];
  if (sensor.isPulse()) {
    //create cards for slis
    dynamic slil = (sensor as Pulse).slil; //left sli
    dynamic slir = (sensor).slir; //right sli
    for (dynamic sli in sensor.sli!) {
      String pid = sli["PID"].toString();
      dynamic sid = sli["SID"];

      if (sid == slil || sid == slir && (slil != 0 || slir != 0)) {
        for (String functionality in sli["plottable"]) {
          if (functionality == "IP" ||
              functionality == "APN" ||
              functionality == "TXT" ||
              functionality == "LAT2" ||
              functionality == "LON2") {
            continue;
          }
          cards.add(new SparklineCardV2(
              name: functionality,
              index: sli["plottable"].indexOf(functionality),
              sli: pid,
              sensor: sensor,
              function: new Functionality(
                  color: null,
                  icon: null,
                  key: functionality,
                  name: functionality,
                  value: null,
                  unit: null)));
        }
      }
    }
  }
  if (sensor.functionalities != null) {
    for (Functionality func in sensor.functionalities!) {
      if (func.key == "IP" ||
          func.key == "APN" ||
          func.key == "TXT" ||
          func.key == "LAT2" ||
          func.key == "BUF" ||
          func.key == "NET" ||
          func.key == "LON2") {
        continue;
      }
      cards.add(new SparklineCardV2(
          name: func.name,
          index: sensor.functionalities!.indexOf(func),
          sli: "",
          sensor: sensor,
          function: func));
    }
  }

  return cards;
}

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
          sli: "",
          name: e.getKey,
          data: controller.convertTimeSeriestoList(e.getTimeSeries!)));
    });
  });
  return sparkLines;
}
