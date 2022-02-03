import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SummaryCardBuilder.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';

class SensorSummaryPage extends StatelessWidget {
  final Sensor sensor;
  const SensorSummaryPage({Key? key, required this.sensor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(sensor.name ?? ""),
        //actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.today))],
      ),
      body: Center(
        child: Container(
          //padding: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width * 9.5 / 10,
          height: MediaQuery.of(context).size.height,
          child: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: SizedBox(
                child: buildSummaryCards(sensor: sensor, context: context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
