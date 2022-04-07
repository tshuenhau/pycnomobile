import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/widgets/BasicSummaryCard.dart';
import 'package:pycnomobile/widgets/MultiSummaryCard.dart';

Widget buildSummaryCards(
    {required Sensor sensor, required BuildContext context}) {
  List<Widget> leftColumn = [];
  List<Widget> rightColumn = [];

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

  if (sensor.sli != null) {
    print("PULSE");
    print(sensor.sli);
  }

  if (sensor.functionalities != null) {
    for (Functionality func in sensor.functionalities!) {
      if (func.value is List<Functionality?>) {
        List<Functionality?> subFunctions = func.value; // like s1t, s2t
        if (subFunctions.isEmpty) {
          continue;
        }
        add(new MultiSummaryCard(
            data: Map.fromIterable(subFunctions.where((e) => e != null),
                key: (e) => e.name, value: (e) => e.value),
            sensor: sensor,
            function: func,
            subFunctions: subFunctions));
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.start, children: leftColumn),
        Column(
            mainAxisAlignment: MainAxisAlignment.start, children: rightColumn)
      ],
    ),
  );
}
