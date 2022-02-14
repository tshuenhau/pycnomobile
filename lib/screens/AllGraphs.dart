import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SummaryCardBuilder.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';

class AllGraphs extends StatelessWidget {
  final Sensor sensor;
  const AllGraphs({Key? key, required this.sensor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      //padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width * 9.5 / 10,
      height: MediaQuery.of(context).size.height,
      child: Align(
          alignment: Alignment.topLeft,
          child: ListView(children: [Text("nothing for now")])),
    ));
  }
}
