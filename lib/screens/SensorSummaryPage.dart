import 'package:flutter/material.dart';
import 'package:pycnomobile/model/Sensor.dart';
import 'package:pycnomobile/widgets/BasicSummaryCard.dart';
import 'package:pycnomobile/widgets/CustomBottomNavigationBar.dart';

class SensorSummaryPage extends StatelessWidget {
  final Sensor sensor;
  const SensorSummaryPage({Key? key, required this.sensor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sensor.name ?? ""),
        actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.today))],
      ),
      body: Center(
        child: Container(
          //padding: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width * 9.5 / 10,
          height: MediaQuery.of(context).size.height,
          child: Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: 2, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: [
                BasicSummaryCard(
                    icon: Icons.thermostat,
                    color: Colors.red,
                    value: 17.55,
                    unit: "°C"),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 1),
    );
  }
}
