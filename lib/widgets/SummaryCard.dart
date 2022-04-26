import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/widgets/GraphBottomSheet.dart';

class SummaryCard extends StatelessWidget {
  final Sensor sensor;
  final Widget child;

  final List<Functionality?> functions;
  const SummaryCard({
    Key? key,
    required this.child,
    required this.sensor,
    required this.functions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Container();
                      // return GraphBottomSheet(
                      //     sensor: sensor, functions: functions);
                    });
              },
              child: child)),
    );
  }
}
