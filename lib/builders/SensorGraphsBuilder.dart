import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/model/LogSeries.dart';
import 'package:pycnomobile/controllers/TimeSeriesController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pycnomobile/widgets/Logs.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';

Future<void> initGraphs(bool isAlert, Sensor sensor,
    List<Functionality?> functions, String sliPid, String sliName, String name,
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

    if (functions.length <= 1) {
      //for non sli graph bottom sheet
      controller.getSingleTimeSeries(dateRange.start, dateRange.end, sensor,
          isAlert, sliPid, sliName, functions);
    } else {
      controller.getMultiTimeSeries(
          dateRange.start, dateRange.end, functions, sensor, isAlert);
    }
  }
}

Future<void> initOldGraphs(
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
    controller.getOldSliTimeSeries(
        dateRange.start, dateRange.end, functions, sensor, isAlert);
  }
}

Future<void> getGraphsForTimeRange(
  bool isAlert,
  DateTimeRange dateRange,
  Sensor sensor,
  List<Functionality?> functions,
  String sliPid,
  String sliName,
  String name,
) async {
  TimeSeriesController controller = Get.put(TimeSeriesController());

  if (sensor.functionalities != null) {
    await controller.getMultiTimeSeries(
      dateRange.start,
      dateRange.end.add(Duration(days: 1)),
      functions,
      sensor,
      isAlert,
    );
  }

  EasyLoading.dismiss();
}

List<Widget> buildGraphs(
    {required Sensor sensor,
    required List<Functionality?> functions,
    required BuildContext context,
    required TYPE_OF_TIMESERIES type,
    required bool isAlert}) {
  TimeSeriesController controller = Get.put(TimeSeriesController());

  List<Widget> graphsToDraw = <Widget>[];
  int drawnCount = 0;
  int count = (type == TYPE_OF_TIMESERIES.OLD_SLI
      ? controller.countOldGraphs(sensor)
      : type == TYPE_OF_TIMESERIES.SLI
          ? controller.countSliGraphs(sensor)
          : type == TYPE_OF_TIMESERIES.INTERNAL
              ? controller.countNumberOfGraphs(functions)
              : 1);

  Widget buildLoadingIndicator() {
    if (drawnCount == count) {
      return Container();
    }
    List<Widget> loadingIndicators = [];
    for (int i = drawnCount; i < count; i++) {
      loadingIndicators.add(LoadingIndicator());
    }
    return Column(
      children: <Widget>[] + loadingIndicators,
    );
    //return LoadingIndicator();
  }

  if (count <= 0) {
    graphsToDraw.add(NoGraphData());
  }

  //! the graphs load out of sequence, i.e the pulse graphs should only load after the internal graphs
  if (sensor.isPulse() &&
      (type == TYPE_OF_TIMESERIES.SLI ||
          type == TYPE_OF_TIMESERIES.OLD_SLI ||
          type == TYPE_OF_TIMESERIES.SINGLE_SLI)) {
    RxList<RxMap<String, RxList<TimeSeries>>> sliGraphs = (type ==
                TYPE_OF_TIMESERIES.SLI ||
            type == TYPE_OF_TIMESERIES.SINGLE_SLI)
        ? (isAlert ? controller.sliAlertGraphs : controller.sliGraphs)
        : (isAlert ? controller.oldSliAlertGraphs : controller.oldSliGraphs);

    sliGraphs.last.forEach((key, value) {
      graphsToDraw.add(Container(
          height: MediaQuery.of(context).size.height * 5 / 100,
          child: Text(
            key, //! this needs to be the more detailed stuff
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
      if (value.length < 1) {
        graphsToDraw.add(Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 7.5 / 100),
          child: Container(
              height: MediaQuery.of(context).size.height * 20 / 100,
              width: MediaQuery.of(context).size.width * 80 / 100,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 1 / 100),
                child: Center(
                  child: Text(
                      "This SLI has sent data but no plottable data streams are available.",
                      textAlign: TextAlign.center),
                ),
              )),
        ));
      }
      value.forEach((element) {
        // if (element.getTimeSeries == null) {
        //   graphsToDraw.add(Container(
        //       height: MediaQuery.of(context).size.height * 10 / 100,
        //       child: Text(
        //           "This SLI has sent data but no plottable data streams are available.",
        //           textAlign: TextAlign.center)));
        // }
        drawnCount += 1;
        if (element.isTimeSeries()) {
          graphsToDraw.add(SensorLineChart(timeSeries: element));
        } else {
          //LogSeries
          graphsToDraw.add(
            Logs(
              data: (element as LogSeries).getLogSeries ?? {},
            ),
          );
        }
      });
    });
  } else if (type == TYPE_OF_TIMESERIES.INTERNAL ||
      type == TYPE_OF_TIMESERIES.SINGLE_INTERNAL) {
    RxList<TimeSeries> internalGraphs =
        isAlert ? controller.alertGraphs.last : controller.graphs.last;

    if (sensor.isPulse() && type != TYPE_OF_TIMESERIES.SINGLE_INTERNAL) {
      graphsToDraw.add(Container(
          height: MediaQuery.of(context).size.height * 5 / 100,
          child: Text(
            "Internal Pulse Sensors",
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
    }

    internalGraphs.forEach((TimeSeries e) {
      drawnCount += 1;
      if (e.isTimeSeries()) {
        graphsToDraw.add(SensorLineChart(timeSeries: e));
      } else {
        //LogSeries
        graphsToDraw.add(
          Logs(
            data: (e as LogSeries).getLogSeries ?? {},
          ),
        );
      }
    });
  }
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
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 4.5 / 100),
      child: Container(
          width: MediaQuery.of(context).size.width * 80 / 100,
          height: MediaQuery.of(context).size.height * 20 / 100,
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary)),
          child: Center(child: Text("No Current SLI Data"))),
    );
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
          top: MediaQuery.of(context).size.height * 7 / 100,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
          ),
          height: MediaQuery.of(context).size.height * 22 / 100,
          width: MediaQuery.of(context).size.width * 80 / 100,
          child: Center(
            child: SizedBox(
                height: MediaQuery.of(context).size.width * 5 / 100,
                width: MediaQuery.of(context).size.width * 5 / 100,
                child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
