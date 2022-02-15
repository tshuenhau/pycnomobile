import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/widgets/GraphBottomSheet.dart';

class SummaryCard extends StatelessWidget {
  final Sensor sensor;
  final Widget child;
  final List<Functionality> functions;
  const SummaryCard(
      {Key? key,
      required this.child,
      required this.sensor,
      required this.functions})
      : super(key: key);

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
                      return GraphBottomSheet(
                          sensor: sensor, functions: functions);
                    });

                // DateTimeRange? _newDateRange = await showDateRangePicker(
                //     context: context,
                //     initialDateRange: DateTimeRange(
                //         start: DateTime.now(), end: DateTime.now()),
                //     firstDate: DateTime(1800),
                //     lastDate: DateTime(3000),
                //     builder: (context, child) {
                //       return child!;
                //     });
                // //print(_newDateRange); //!graphBuilder with new dates
                // if (_newDateRange != null) {
                //   //! generatenew graphs with the new date range
                //   buildSensorGraphs(context, sensor, functions, _newDateRange);
                // }
              },
              //buildSensorGraphs(context, sensor, functions)},
              child: child)),
    );
  }
}
