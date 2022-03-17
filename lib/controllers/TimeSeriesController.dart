import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TimeSeriesController extends GetxController {
  TimeSeries? currentTimeSeries;
  AuthController authController = Get.find();
  RxList<RxList<TimeSeries?>> graphs = RxList<RxList<TimeSeries?>>.empty();
  RxList<RxList<TimeSeries?>> alertGraphs = RxList<RxList<TimeSeries?>>.empty();
  CancelableOperation? cancelableTimeSeries;

  static Map<int, double> convertListToMap(List list) {
    return Map.fromIterable(list.reversed.where((e) => e[1] != null),
        key: (e) => e[0].toInt(), value: (e) => e[1].toDouble());
  }

  @override
  void onInit() async {
    // initGraphs(sensor, sensor.functionalities!);
    super.onInit();
  }

  // Future<void> initGraphs(Sensor sensor, List<Functionality?> functions,
  //     [DateTimeRange? dateRange]) async {
  //   if (dateRange == null) {
  //     dateRange = new DateTimeRange(
  //         start: DateTime.now().add(Duration(hours: -24)), end: DateTime.now());
  //   } else if (dateRange.duration.inDays <= 0) {
  //     DateTime now = DateTime.now();
  //     dateRange = DateTimeRange(
  //         start: DateTime(now.year, now.month, now.day, 0, 0),
  //         end: DateTime(now.year, now.month, now.day, 23, 59));
  //   } else {
  //     dateRange = DateTimeRange(
  //         start: dateRange.start,
  //         end: DateTime(dateRange.end.year, dateRange.end.month,
  //             dateRange.end.day, 23, 59));
  //   }

  //   if (sensor.functionalities != null) {
  //     getMultiTimeSeries(dateRange.start, dateRange.end, functions, sensor);
  //   }
  // }

  // Future<List<TimeSeries>?> getGraphsForTimeRange(DateTimeRange dateRange,
  //     Sensor sensor, List<Functionality?> functions) async {
  //   print("GET GRAPHS FOR TIME RANGE");
  //   final List<TimeSeries> graphs = [];

  //   if (sensor.functionalities != null) {
  //     await getMultiTimeSeries(dateRange.start,
  //         dateRange.end.add(Duration(days: 1)), functions, sensor);
  //   }

  //   EasyLoading.dismiss();

  //   return graphs;
  // }

  // List<Widget> buildGraphs(
  //     Sensor sensor, List<Functionality?> functions, BuildContext context) {
  //   //PROBLEM IS THIS FUNCTION
  //   print("BUILD GRAPHS HEHEH");

  //   AuthController auth = Get.find();
  //   List<Widget> graphsToDraw = <Widget>[];
  //   int drawnCount = 0;
  //   Widget buildLoadingIndicator() {
  //     if (drawnCount == countNumberOfGraphs(functions)) {
  //       return Container();
  //     }
  //     List<Widget> loadingIndicators = [];
  //     for (int i = drawnCount; i < countNumberOfGraphs(functions); i++) {
  //       loadingIndicators.add(LoadingIndicator(context));
  //     }
  //     return Column(
  //       children: <Widget>[] + loadingIndicators,
  //     );
  //     //return LoadingIndicator();
  //   }

  //   if (countNumberOfGraphs(functions) <= 0) {
  //     graphsToDraw.add(NoGraphData(context));
  //   }

  //   graphs.last.forEach((e) {
  //     drawnCount += 1;
  //     if (e != null) {
  //       graphsToDraw.add(SensorLineChart(
  //           data: e.getTimeSeries,
  //           functionName: e
  //               .getKey)); //I put ! behind the e just to avoid error, idk if will have any bugs
  //     } else {
  //       graphsToDraw.add(NoGraphData(context));
  //     }
  //   });

  //   List<Widget> result = [
  //     Column(children: <Widget>[] + graphsToDraw),
  //     buildLoadingIndicator()
  //   ];

  //   return result;
  // }

  Future<void> getMultiTimeSeries(DateTime start, DateTime end,
      List<Functionality?> functions, Sensor sensor) async {
    RxList<TimeSeries?> instanceList = new RxList.empty(growable: true);

    if (authController.currentTab.value == 0) {
      print("SENSORS");
      graphs.add(instanceList);
    } else {
      print("ALERTS");
      alertGraphs.add(instanceList);
    }

    for (Functionality? function in functions) {
      if (function != null) {
        if (function.value is List) {
          //multi value
          List func = function.value;

          for (Functionality? subfunc in func) {
            if (subfunc != null) {
              final response = await http.get(Uri.parse(
                  'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${subfunc.key}&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));
              // print(
              //     'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${subfunc.key}&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}');
              if (response.statusCode == 200) {
                if (jsonDecode(response.body).length <= 0) {
                  continue;
                }
                var body = jsonDecode(response.body)[0];

                String color = body['color'];
                String key = body['key'];
                if (body["values"] == null) {
                  instanceList.add(null);
                  continue;
                }
                Map<int, double> timeSeries = convertListToMap(body['values']);
                instanceList.add(new TimeSeries(
                    key: key, color: color, timeSeries: timeSeries));
              } else {
                throw Exception("Failed to retrieve data"); //Ask UI to reload
              }
            }
          }
        } else {
          final response = await http.get(Uri.parse(
              'https://stage.pycno.co.uk/api/v2/data/1?TK=${authController.token}&UID=${sensor.uid}&${function.key}&start=${start.toUtc().toIso8601String()}&end=${end.toUtc().toIso8601String()}'));

          if (response.statusCode == 200) {
            if (jsonDecode(response.body).length <= 0) {
              continue;
            }
            var body = jsonDecode(response.body)[0];

            String color = body['color'];
            String key = body['key'];
            if (body["values"] == null) {
              instanceList.add(null);
              continue;
            }
            Map<int, double> timeSeries = convertListToMap(body['values']);
            instanceList.add(
                new TimeSeries(key: key, color: color, timeSeries: timeSeries));
          } else {
            throw Exception("Failed to retrieve data"); //Ask UI to reload
          }
        }
      }
    }
    if (graphs.length > 1) {
      graphs.removeRange(0, graphs.length - 1);
    } else {
      alertGraphs.removeRange(0, graphs.length - 1);
    }
  }

  int countNumberOfGraphs(List<Functionality?> functions) {
    int count = 0;
    for (Functionality? function in functions) {
      if (function == null) {
        continue;
      }
      if (function.value is List) {
        List<Functionality?> subFunc = function.value;
        List<Functionality?> nonNullFunctions =
            subFunc.where((e) => e != null).toList();

        count += nonNullFunctions.length;
      } else {
        count += 1;
      }
    }
    return count;
  }
}

// Future<void> createCancelableTimeSeries(DateTime start, DateTime end,
//     List<Functionality?> functions, Sensor sensor) async {
//   cancelableTimeSeries?.cancel();
//   cancelableTimeSeries = CancelableOperation.fromFuture(
//       getMultiTimeSeries(start, end, functions, sensor), onCancel: () {
//     print("Operation cancelled");
//     graphs.clear();
//     print(graphs);
//   });
// }

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
