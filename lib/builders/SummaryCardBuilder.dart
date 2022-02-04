import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/sensors/MasterSoilSensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/widgets/BasicSummaryCard.dart';
import 'package:pycnomobile/widgets/MultiSummaryCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';

Widget buildSummaryCards(
    {required Sensor sensor, required BuildContext context}) {
  List<Widget> leftColumn = [];
  List<Widget> rightColumn = [];
  int leftCount = 0;
  int rightCount = 0;
  /*
  leftColumn  rightColumn
      1           2
      3           4
      5           6
 */
  void add(Widget card) {
    if (leftColumn.isEmpty) {
      leftColumn.add(card);
    } else if (leftColumn.length <= rightColumn.length) {
      leftColumn.add(card);
    } else {
      rightColumn.add(card);
    }
  }

  if (sensor.functionalities != null) {
    for (Functionality func in sensor.functionalities!) {
      if (func.value is List<Functionality>) {
        add(new MultiSummaryCard(
            //! Maybeb do a check here? for whether the stuff in List<Functionality> has a graph or not
            data: Map.fromIterable(func.value,
                key: (e) => e.name, value: (e) => e.value),
            sensor: sensor,
            function: func,
            functions: func.value));
      } else {
        add(new BasicSummaryCard(
            //TODO: Refactor these stuff especially the func.icon, func.color bs, just pass one func is enough.
            sensor: sensor,
            function: func));
        // add(new BasicSummaryCard(
        //     //TODO: Refactor these stuff especially the func.icon, func.color bs, just pass one func is enough.
        //     sensor: sensor,
        //     function: func));
      }
    }
  }

  return IntrinsicHeight(
    child: Row(
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.start, children: leftColumn),
        Column(
            mainAxisAlignment: MainAxisAlignment.start, children: rightColumn)
      ],
    ),
  );
}
