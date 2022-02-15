import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SummaryCardBuilder.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/screens/AllGraphsPage.dart';

class SensorPage extends StatelessWidget {
  final Sensor sensor;
  const SensorPage({Key? key, required this.sensor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(sensor.name ?? ""),
        elevation: 0,
        //actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.today))],
      ),
      body: Center(
        child: Container(
          //padding: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width * 9.5 / 10,
          height: MediaQuery.of(context).size.height,
          child: PageView(children: [
            SensorSummaryPage(sensor: sensor),
            AllGraphsPage(sensor: sensor)
          ]),
        ),
      ),
    );
  }
}

class SensorSummaryPage extends StatelessWidget {
  const SensorSummaryPage({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  final Sensor sensor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: buildSummaryCards(sensor: sensor, context: context),
      ),
    );
  }
}
