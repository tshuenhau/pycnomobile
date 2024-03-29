import 'package:flutter/material.dart';
import 'package:Sensr/model/sensors/Sensor.dart';
import 'package:Sensr/model/functionalities/Functionality.dart';
import 'package:Sensr/widgets/BasicSummaryCard.dart';
import 'package:Sensr/widgets/MultiSummaryCard.dart';
import 'package:Sensr/widgets/TitleSummaryCard.dart';

Widget buildSummaryCards(
    {required Sensor sensor, required BuildContext context}) {
  List<Widget> leftColumn = [];
  List<Widget> rightColumn = [];

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
        if (func.icon == null) {
          add(new TitleSummaryCard(sensor: sensor, function: func));
        } else {
          add(new BasicSummaryCard(sensor: sensor, function: func));
        }
        // add(new BasicSummaryCard(
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
