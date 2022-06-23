import 'package:flutter/material.dart';
import 'package:Sensr/model/sensors/Sensor.dart';
import 'package:Sensr/model/TimeSeries.dart';
import 'package:Sensr/model/LogSeries.dart';
import 'package:Sensr/controllers/TimeSeriesController.dart';
import 'package:Sensr/model/functionalities/Functionality.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Sensr/widgets/Logs.dart';
import 'package:Sensr/widgets/SensorLineChart.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    if (functions.length <= 1) {
      //for non sli graph bottom sheet
      await controller.getSingleTimeSeries(dateRange.start, dateRange.end,
          sensor, isAlert, sliPid, sliName, functions);
    } else {
      await controller.getMultiTimeSeries(
          dateRange.start, dateRange.end, functions, sensor, isAlert);
    }
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
      children: <Widget>[] +
          loadingIndicators +
          [SizedBox(height: MediaQuery.of(context).size.height * 2.5 / 100)],
    );
    //return LoadingIndicator();
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
      // if (value.length < 1) {
      //   graphsToDraw.add(Padding(
      //     padding: EdgeInsets.only(
      //         bottom: MediaQuery.of(context).size.height * 7.5 / 100),
      //     child: Container(
      //         height: MediaQuery.of(context).size.height * 20 / 100,
      //         width: MediaQuery.of(context).size.width * 80 / 100,
      //         decoration: BoxDecoration(
      //             border:
      //                 Border.all(color: Theme.of(context).colorScheme.primary)),
      //         child: Padding(
      //           padding: EdgeInsets.symmetric(
      //               horizontal: MediaQuery.of(context).size.width * 1 / 100),
      //           child: Center(
      //             child: Text(
      //                 "This SLI has sent data but no plottable data streams are available.",
      //                 textAlign: TextAlign.center),
      //           ),
      //         )),
      //   ));
      // }
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
          graphsToDraw.add(SensorLineChart(timeSeries: element, type: type));
        } else {
          //LogSeries
          graphsToDraw.add(
            Logs(
              title: (element as LogSeries).getName,
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
        graphsToDraw.add(SensorLineChart(timeSeries: e, type: type));
      } else {
        //LogSeries
        graphsToDraw.add(
          Logs(
            title: (e as LogSeries).getName,
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

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectionStatus = ConnectivityResult.wifi;
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

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
              child: _connectionStatus == ConnectivityResult.none
                  ? Text("Error Loading Data")
                  : SizedBox(
                      height: MediaQuery.of(context).size.width * 5 / 100,
                      width: MediaQuery.of(context).size.width * 5 / 100,
                      child: CircularProgressIndicator())),
        ),
      ),
    );
  }
}
