import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/TimeSeriesController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';

Future<List<TimeSeries>> buildSensorGraphs(
    Sensor sensor, List<Functionality?> functions,
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

  final List<TimeSeries> graphs = [];

  TimeSeriesController controller = Get.put(TimeSeriesController());

  if (sensor.functionalities != null) {
    print("number of graphs " +
        controller.countNumberOfGraphs(functions).toString());
    controller.getMultiTimeSeries(
        dateRange.start, dateRange.end, functions, sensor);
  }
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

  TimeSeriesController controller = Get.put(TimeSeriesController());

  if (sensor.functionalities != null) {
    controller.getMultiTimeSeries(dateRange.start,
        dateRange.end.add(Duration(days: 1)), functions, sensor);
  }

  EasyLoading.dismiss();

  if (isDismissed) {
    return null;
  } else
    return graphs;
}

List<Widget> buildGraphs(BuildContext context, List<Functionality?> functions) {
  TimeSeriesController controller = Get.find();
  List<Widget> graphsToDraw = <Widget>[];
  int drawnCount = 0;
  int currCount = 0;

  Widget buildLoadingIndicator(BuildContext context) {
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
    //TODO: need to change this to when we can figure out how many graphs tehere will be
    graphsToDraw.add(Center(child: Text("No data for selected time period")));
  }
  controller.graphs.forEach((e) {
    drawnCount += 1;
    graphsToDraw.add(SensorLineChart(
        key: UniqueKey(), data: e.getTimeSeries, functionName: e.getKey));
  });
  // graphs.forEach((key, value) {
  //   graphsToDraw.add(SensorLineChart(data: value, function: key));
  // });
  List<Widget> result = [
    Column(children: <Widget>[] + graphsToDraw),
    buildLoadingIndicator(context)
  ];

  return result;
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
