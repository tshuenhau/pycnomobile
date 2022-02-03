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
    {DateTimeRange? dateRange}) async {
  EasyLoading.show(status: 'loading...');
  bool isDismissed = false;

  if (dateRange == null) {
    dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  }

  final List<TimeSeries> graphs = [];

  TimeSeriesController controller = Get.put(TimeSeriesController());

  EasyLoading.addStatusCallback((status) {
    if (status == EasyLoadingStatus.dismiss) {
      print("dismiss");
      isDismissed = true;
      //!Need to try to stop the async await function here since we "dismissed" the loading and no longer want the graph
    }
  });
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
  if (isDismissed) {
    return;
  } else {
    EasyLoading.dismiss();

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return GraphBottomSheet(
              dateRange: dateRange,
              graphs: graphs,
              sensor: sensor,
              functions: functions);
        });
  }
}
