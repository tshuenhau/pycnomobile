import 'package:flutter/material.dart';
import 'package:pycnomobile/model/Sensor.dart';
import 'package:pycnomobile/model/SoilSensor.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/TimeSeriesController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/widgets/GraphBottomSheet.dart';
import 'package:get/get.dart';

Future<dynamic> buildSensorGraphs(
    BuildContext context, Sensor sensor, List<Functionality> functions) async {
  //! parameters include a List<functionality> to take care of the multisummarycards
  print(
      functions); //! should print out all the list of functionalities to graph

  //! basically make a map of functionality: data, if just have 1 functionality then it just has 1 entry.
  final List<TimeSeries> graphs = [];

  TimeSeriesController controller = Get.put(TimeSeriesController());
  if (sensor.functionalities != null) {
    //Multi so need to split up
    for (Functionality function in functions) {
      try {
        await controller.getTimeSeries(
            DateTime.fromMillisecondsSinceEpoch(1643108878837),
            DateTime.fromMillisecondsSinceEpoch(1827299202217),
            function.key,
            sensor);
        if (controller.currentTimeSeries != null) {
          graphs.add(controller.currentTimeSeries!);
          print(graphs);
        }
      } catch (e) {
        // TODO: handle exception in the UI
      }
    }
  }

//! Do api calls here.
  final Map<int, double> data = {
    //! Example data, time in milliseconds since 1970 thing: value
    //! Just to be clear, the x value is the date which is in milliseconds since 1970, then the y value is just the value
    1643108878837: 20.55,
    1643126400000: 20.23,
    1653212800000: 20.55,
    1663299200000: 26.23,
    1673212800001: 20.55,
    1683299200002: 26.23,
    1693212800003: 20.55,
    1703299200004: 26.23,
    1713212800005: 20.55,
    1723299200006: 26.23,
    1733212800007: 20.55,
    1743299200008: 26.23,
    1753212800009: 20.55,
    1763299200012: 26.23,
    1773212800013: 20.55,
    1783299200014: 26.23,
    1793212800015: 20.55,
    1803299200016: 26.23,
    1813299202216: 28.55,
    1813299202217: 27.55,
    1814299202217: 27.55,
    1815299202217: 27.55,
    1816299202217: 27.55,
    1817299202217: 27.55,
    1827299202217: 27.55,
  };

  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return GraphBottomSheet(
          graphs: graphs,
        );
      });
}
