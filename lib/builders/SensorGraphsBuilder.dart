import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/TimeSeriesController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/widgets/GraphBottomSheet.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<dynamic> buildSensorGraphs(
    BuildContext context, Sensor sensor, List<Functionality> functions,
    [DateTimeRange? dateRange]) async {
  EasyLoading.show(status: 'loading...');

  if (dateRange == null) {
    dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  }

  final List<TimeSeries> graphs = [];

  TimeSeriesController controller = Get.put(TimeSeriesController());

  EasyLoading.addStatusCallback((status) {
    if (status == EasyLoadingStatus.dismiss) {
      return; //!Need to try to stop the async await function here since we "dismissed" the loading and no longer want the graph
    }
  });
  if (sensor.functionalities != null) {
    //Multi so need to split up
    for (Functionality function in functions) {
      try {
        await controller.getTimeSeries(
            dateRange
                .start, //!probably change tis to the dateRange.start and dateRange.end
            dateRange.end,
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

  EasyLoading.dismiss();

  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GraphBottomSheet(
            dateRange: dateRange,
            graphs: graphs,
            sensor: sensor,
            functions: functions);
      });
}

Future<List<TimeSeries>?> getGraphsForTimeRange(DateTimeRange dateRange,
    Sensor sensor, List<Functionality> functions) async {
  print(dateRange);
  final List<TimeSeries> graphs = [];
  EasyLoading.show(status: 'loading...');
  EasyLoading.addStatusCallback((status) {
    if (status == EasyLoadingStatus.dismiss) {
      return null;
    }
  });

  TimeSeriesController controller = Get.put(TimeSeriesController());

  if (sensor.functionalities != null) {
    //Multi so need to split up
    for (Functionality function in functions) {
      try {
        await controller.getTimeSeries(
            dateRange.start, dateRange.end, function.key, sensor);

        if (controller.currentTimeSeries != null) {
          graphs.add(controller.currentTimeSeries!);
        }
      } catch (e) {
        // TODO: handle exception in the UI
      }
    }
  }

  EasyLoading.dismiss();
  return graphs;
}
