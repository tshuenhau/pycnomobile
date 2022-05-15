import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/TimeSeriesController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
      print('getting single, sli ' + sliPid);
      controller.getSingleTimeSeries(dateRange.start, dateRange.end, sensor,
          isAlert, sliPid, sliName, functions);
    } else {
      print('getting multi');
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
      value.forEach((element) {
        if (element.getTimeSeries == null) {
          graphsToDraw.add(Container(
              height: MediaQuery.of(context).size.height * 10 / 100,
              child: Text(
                  " This SLI has sent data but no plottable data streams are available.",
                  textAlign: TextAlign.center)));
        }
        drawnCount += 1;
        if (element.isTimeSeries()) {
          graphsToDraw.add(SensorLineChart(timeSeries: element));
        } else {
          //LogSeries
          //TODO: add logs widget here
          print("Drawing log series");
          graphsToDraw.add(
            Logs(),
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
        print("Drawing log series");
        graphsToDraw.add(
          Logs(),
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

class Logs extends StatelessWidget {
  const Logs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 5 / 100,
          child: Center(
              child: Text("Log",
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.height * 2.5 / 100))),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 2.5 / 100,
              horizontal: MediaQuery.of(context).size.width * 2.5 / 100),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.45))),
            height: MediaQuery.of(context).size.height * 20 / 100,
            child: Container(
              height: MediaQuery.of(context).size.height * 25 / 100,
              child: Scrollbar(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: ClampingScrollPhysics(),
                    child: Scrollbar(
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: Scrollbar(
                        scrollbarOrientation: ScrollbarOrientation.left,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "Hi------------------------------------------------------------------------------------------------------------------------"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte"),
                              Text("bte")
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }
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
