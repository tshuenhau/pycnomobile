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

Future<void> initGraphs(
    bool isAlert, Sensor sensor, List<Functionality?> functions,
    [DateTimeRange? dateRange]) async {
  if (dateRange == null) {
    dateRange = new DateTimeRange(
        start: DateTime.now().add(Duration(hours: -24 * 7)),
        end: DateTime.now());
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

  if (sensor.functionalities != null) {
    TimeSeriesController controller = Get.put(TimeSeriesController());
    controller.getMultiTimeSeries(
        dateRange.start, dateRange.end, functions, sensor, isAlert);
  }
}

Future<void> getGraphsForTimeRange(bool isAlert, DateTimeRange dateRange,
    Sensor sensor, List<Functionality?> functions) async {
  TimeSeriesController controller = Get.put(TimeSeriesController());

  if (sensor.functionalities != null) {
    await controller.getMultiTimeSeries(dateRange.start,
        dateRange.end.add(Duration(days: 1)), functions, sensor, isAlert);
  }

  EasyLoading.dismiss();
}

List<Widget> buildGraphs(Sensor sensor, List<Functionality?> functions,
    BuildContext context, bool isAlert) {
  TimeSeriesController controller = Get.put(TimeSeriesController());

  List<Widget> graphsToDraw = <Widget>[];
  List<Widget> sliGraphsToDraw = <Widget>[];

  int drawnCount = 0;

  Widget buildLoadingIndicator() {
    if (drawnCount == controller.countNumberOfGraphs(functions)) {
      return Container();
    }
    List<Widget> loadingIndicators = [];
    for (int i = drawnCount;
        i < controller.countNumberOfGraphs(functions);
        i++) {
      loadingIndicators.add(LoadingIndicator());
    }
    return Column(
      children: <Widget>[] + loadingIndicators,
    );
    //return LoadingIndicator();
  }

  if (controller.countNumberOfGraphs(functions) <= 0) {
    graphsToDraw.add(NoGraphData());
  }
  if (isAlert == true) {
    controller.alertGraphs.last.forEach((e) {
      drawnCount += 1;
      graphsToDraw.add(SensorLineChart(
        timeSeries: e,
      )); //I put ! behind the e just to avoid error, idk if will have any bugs
    });
  } else {
    //! the graphs load out of sequence, i.e the pulse graphs should only load after the internal graphs
    if (sensor.isPulse()) {
      controller.sliGraphs.last.forEach((key, value) {
        print(key.toString() + " " + value.toString() + "");

        sliGraphsToDraw.add(Container(
            height: MediaQuery.of(context).size.height * 5 / 100,
            child: Text(
              key,
              style: TextStyle(fontWeight: FontWeight.bold),
            )));
        if (value!.length < 1) {
          sliGraphsToDraw.add(Container(
              height: MediaQuery.of(context).size.height * 10 / 100,
              child: Text(
                  " This SLI has sent data but no plottable data streams are available.",
                  textAlign: TextAlign.center)));
        }
        value.forEach((element) {
          drawnCount += 1;
          sliGraphsToDraw.add(SensorLineChart(timeSeries: element));
        });
      });
    }
    graphsToDraw.add(Container(
        height: MediaQuery.of(context).size.height * 5 / 100,
        child: Text(
          "Internal Pulse Sensors",
          style: TextStyle(fontWeight: FontWeight.bold),
        )));
    controller.graphs.last.forEach((TimeSeries e) {
      drawnCount += 1;
      graphsToDraw.add(SensorLineChart(
        timeSeries: e,
      )); //I put ! behind the e just to avoid error, idk if will have any bugs
    });
  }

  List<Widget> result = [
    Column(children: <Widget>[] + sliGraphsToDraw + graphsToDraw),
    buildLoadingIndicator()
  ];

  return result;
}

List<Widget> buildOldGraphs(
    Sensor sensor, List<Functionality?> functions, BuildContext context) {
  TimeSeriesController controller = Get.put(TimeSeriesController());

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
      loadingIndicators.add(LoadingIndicator());
    }
    return Column(
      children: <Widget>[] + loadingIndicators,
    );
    //return LoadingIndicator();
  }

  if (controller.countNumberOfGraphs(functions) <= 0) {
    graphsToDraw.add(NoGraphData());
  }

  controller.graphs.last.forEach((TimeSeries e) {
    drawnCount += 1;
    graphsToDraw.add(SensorLineChart(
      timeSeries: e,
    )); //I put ! behind the e just to avoid error, idk if will have any bugs
  });

  List<Widget> result = [
    Column(children: <Widget>[] + graphsToDraw),
    buildLoadingIndicator()
  ];

  return result;
}

class NoGraphData extends StatelessWidget {
  const NoGraphData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 15 / 100,
        child: Center(child: Text("No Data")));
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
