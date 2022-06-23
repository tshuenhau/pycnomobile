import 'package:flutter/material.dart';
import 'package:Sensr/model/sensors/Sensor.dart';
import 'package:Sensr/widgets/SparklineCard.dart';
import 'package:Sensr/model/sensors/Pulse.dart';
import 'package:Sensr/model/functionalities/Functionality.dart';

// Future<void> initSparklines({required Sensor sensor}) async {
//   SensorInfoController controller = Get.put(SensorInfoController());
//   await controller.getTimeSeriesForSparklines(sensor);
// }

List<Widget> buildSparklines({required Sensor sensor}) {
  List<Widget> cards = [];
  if (sensor.isPulse()) {
    //create cards for slis
    dynamic slil = (sensor as Pulse).slil; //left sli
    dynamic slir = (sensor).slir; //right sli
    for (dynamic sli in sensor.sli!) {
      String pid = sli["PID"].toString();
      dynamic sid = sli["SID"];
      String name = sli["name"].toString();

      if (sid == slil || sid == slir && (slil != 0 || slir != 0)) {
        for (String functionality in sli["plottable"]) {
          if (functionality == "IP" ||
              functionality == "APN" ||
              functionality == "TXT" ||
              functionality == "LAT2" ||
              functionality == "LON2" ||
              functionality == "ICCID") {
            continue;
          }
          cards.add(SparklineCard(
              name: functionality,
              index: sli["plottable"].indexOf(functionality),
              sliPid: pid,
              sliName: name,
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
          func.key == "LON2" ||
          func.key == "ICCID") {
        continue;
      }
      cards.add(new SparklineCard(
          name: func.name,
          index: sensor.functionalities!.indexOf(func),
          sliPid: "",
          sliName: "",
          sensor: sensor,
          function: func));
    }
  }

  return cards;
}
