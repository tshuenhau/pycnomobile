import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/TimeSeriesController.dart';

import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';

Future<void> initGraphs(Sensor sensor, List<Functionality?> functions,
    [DateTimeRange? dateRange]) async {
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

  AuthController auth = Get.find();

  if (sensor.functionalities != null) {
    TimeSeriesController controller = Get.put(TimeSeriesController());
    controller.getMultiTimeSeries(
        dateRange.start, dateRange.end, functions, sensor);
  }
}

Future<void> getGraphsForTimeRange(DateTimeRange dateRange, Sensor sensor,
    List<Functionality?> functions) async {
  print("GET GRAPHS FOR TIME RANGE");

  TimeSeriesController controller = Get.put(TimeSeriesController());

  if (sensor.functionalities != null) {
    await controller.getMultiTimeSeries(dateRange.start,
        dateRange.end.add(Duration(days: 1)), functions, sensor);
  }

  EasyLoading.dismiss();
}

List<Widget> buildGraphs(
    Sensor sensor, List<Functionality?> functions, BuildContext context) {
  //PROBLEM IS THIS FUNCTION
  print("BUILD GRAPHS");
  TimeSeriesController controller = Get.put(TimeSeriesController());

  AuthController auth = Get.find();
  List<Widget> graphsToDraw = <Widget>[];
  int drawnCount = 0;
  Widget buildLoadingIndicator() {
    if (drawnCount == controller.countNumberOfGraphs(functions)) {
      return Container();
    }
    List<Widget> loadingIndicators = [];
    for (int i = drawnCount;
        i < controller.countNumberOfGraphs(functions);
        i++) {
      loadingIndicators.add(LoadingIndicator(context));
    }
    return Column(
      children: <Widget>[] + loadingIndicators,
    );
    //return LoadingIndicator();
  }

  if (controller.countNumberOfGraphs(functions) <= 0) {
    graphsToDraw.add(NoGraphData(context));
  }

  if (auth.currentTab.value == 0) {
    controller.graphs.last.forEach((e) {
      drawnCount += 1;
      if (e != null) {
        graphsToDraw.add(SensorLineChart(
            data: e.getTimeSeries,
            functionName: e
                .getKey)); //I put ! behind the e just to avoid error, idk if will have any bugs
      } else {
        graphsToDraw.add(NoGraphData(context));
      }
    });
  } else {
    controller.alertGraphs.last.forEach((e) {
      drawnCount += 1;
      if (e != null) {
        graphsToDraw.add(SensorLineChart(
            data: e.getTimeSeries,
            functionName: e
                .getKey)); //I put ! behind the e just to avoid error, idk if will have any bugs
      } else {
        graphsToDraw.add(NoGraphData(context));
      }
    });
  }

  List<Widget> result = [
    Column(children: <Widget>[] + graphsToDraw),
    buildLoadingIndicator()
  ];

  return result;
}

// class NoGraphData extends StatelessWidget {
//   const NoGraphData({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         height: MediaQuery.of(context).size.height * 15 / 100,
//         child: Center(child: Text("No Data")));
//   }
// }

Widget NoGraphData(BuildContext context) {
  return SizedBox(
      height: MediaQuery.of(context).size.height * 15 / 100,
      child: Center(child: Text("No Data")));
}

Widget LoadingIndicator(BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 7.5 / 100,
          bottom: MediaQuery.of(context).size.height * 10 / 100),
      child: SizedBox(
          height: MediaQuery.of(context).size.width * 5 / 100,
          width: MediaQuery.of(context).size.width * 5 / 100,
          child: CircularProgressIndicator()),
    ),
  );
}

// class LoadingIndicator extends StatelessWidget {
//   const LoadingIndicator({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.only(
//             top: MediaQuery.of(context).size.height * 7.5 / 100,
//             bottom: MediaQuery.of(context).size.height * 10 / 100),
//         child: SizedBox(
//             height: MediaQuery.of(context).size.width * 5 / 100,
//             width: MediaQuery.of(context).size.width * 5 / 100,
//             child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }
