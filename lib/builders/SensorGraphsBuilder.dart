import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/TimeSeriesController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/widgets/GraphBottomSheet.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';

Future<List<TimeSeries>> buildSensorGraphs(
    Sensor sensor, List<Functionality?> functions,
    [DateTimeRange? dateRange]) async {
  print("Functions " + functions.toString());
  EasyLoading.show(status: 'loading...');
  bool isDismissed = false;

  if (dateRange == null) {
    dateRange = new DateTimeRange(
        start: DateTime.now().add(Duration(hours: -24)), end: DateTime.now());
  } else if (dateRange.duration.inDays <= 0) {
    DateTime now = DateTime.now();
    dateRange = DateTimeRange(
        start: DateTime(now.year, now.month, now.day, 0, 0),
        end: DateTime(now.year, now.month, now.day, 23, 59));
  } else {
    dateRange = DateTimeRange(
        start: dateRange.start,
        end: DateTime(dateRange.end.year, dateRange.end.month,
            dateRange.end.day, 23, 59));
  }

  final List<TimeSeries> graphs = [];

  TimeSeriesController controller = Get.put(TimeSeriesController());

  EasyLoading.addStatusCallback((status) {
    if (status == EasyLoadingStatus.dismiss) {
      isDismissed = true;
      print("Dismissed");
      //!Need to try to stop the async await function here since we "dismissed" the loading and no longer want the graph
    }
  });
  if (sensor.functionalities != null) {
    //Multi so need to split up
    print("number of graphs " +
        controller.countNumberOfGraphs(functions).toString());
    controller.getMultiTimeSeries(
        dateRange.start, dateRange.end, functions, sensor);
    // for (Functionality function in functions) {
    //   //This needs to be async
    //   if (function.value != null) {
    //     try {
    //       // Future<void> futureGetTimeSeries = controller.getTimeSeries(
    //       //     dateRange.start, dateRange.end, function.key, sensor);
    //       // futureGetTimeSeries.whenComplete(() => EasyLoading.dismiss());
    //       await controller.getTimeSeries(
    //           dateRange.start, dateRange.end, function.key, sensor);
    //     } catch (e) {
    //       // TODO: handle exception in the UI
    //     }
    //   }
    // }
    // graphs.addAll(sensor.timeSeriesList); //TODO: this will be the future flow

  }

  EasyLoading.dismiss();
  // if (isDismissed) {
  //   return;
  // } else
  return graphs;
}

Future<List<TimeSeries>?> getGraphsForTimeRange(DateTimeRange dateRange,
    Sensor sensor, List<Functionality?> functions) async {
  final List<TimeSeries> graphs = [];
  EasyLoading.show(status: 'loading...');
  bool isDismissed = false;

  EasyLoading.addStatusCallback((status) {
    if (status == EasyLoadingStatus.dismiss) {
      isDismissed = true;
      print("Dismissed");

      //!Need to try to stop the async await function here since we "dismissed" the loading and no longer want the graph
    }
  });
  // if (dateRange.duration.inDays < 1) {
  //   DateTime now = DateTime.now();
  //   dateRange = DateTimeRange(
  //       start: DateTime(now.year, now.month, now.day, 0, 0),
  //       end: DateTime(now.year, now.month, now.day, 23, 59));
  // }
  TimeSeriesController controller = Get.put(TimeSeriesController());

  if (sensor.functionalities != null) {
    //Multi so need to split up
    controller.getMultiTimeSeries(dateRange.start,
        dateRange.end.add(Duration(days: 1)), functions, sensor);
    // for (Functionality function in functions) {
    //   if (function.value != null) {
    //     try {
    //       await controller.getTimeSeries(dateRange.start,
    //           dateRange.end.add(Duration(days: 1)), function.key, sensor);

    //       if (controller.currentTimeSeries != null) {
    //         graphs.add(controller.currentTimeSeries!);
    //       }
    //     } catch (e) {
    //       // TODO: handle exception in the UI
    //     }
    //   }
    // }
  }

  EasyLoading.dismiss();

  if (isDismissed) {
    return null;
  } else
    return graphs;
}

List<Widget> buildGraphs(BuildContext context) {
  TimeSeriesController controller = Get.find();
  List<Widget> graphsToDraw = <Widget>[];
  graphsToDraw.clear();
  if (controller.graphs.length <= 0) {
    //TODO: need to change this to when we can figure out how many graphs tehere will be
    graphsToDraw.add(Center(child: Text("No data for selected time period")));
  }
  controller.graphs.forEach((e) => {
        graphsToDraw.add(SensorLineChart(
            key: UniqueKey(), data: e.getTimeSeries, functionName: e.getKey))
      });
  // graphs.forEach((key, value) {
  //   graphsToDraw.add(SensorLineChart(data: value, function: key));
  // });
  return graphsToDraw;
}
