import 'dart:async';

import 'package:Sensr/model/TimeSeries.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:Sensr/widgets/GraphBottomSheet.dart';
import 'package:Sensr/model/sensors/Sensor.dart';
import 'package:Sensr/model/functionalities/GenericFunctionality.dart';
import 'package:Sensr/model/functionalities/Functionality.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Sensr/controllers/SensorInfoController.dart';
import 'package:Sensr/controllers/AuthController.dart';
import 'package:collection/collection.dart';

class SparklineCard extends StatefulWidget {
  SparklineCard(
      {Key? key,
      required this.name,
      required this.function,
      required this.sliPid,
      required this.sliName,
      required this.index,
      required this.sensor})
      : super(key: key);

  final String name; //name of sensor
  final Sensor sensor;
  final int index;
  final Functionality function;
  final String sliPid;
  final String sliName;

  @override
  State<SparklineCard> createState() => _SparklineCardState();
}

class _SparklineCardState extends State<SparklineCard> {
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
    SensorInfoController controller = Get.put(SensorInfoController());
    AuthController auth = Get.put(AuthController());

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(onTap: () {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return GraphBottomSheet(
                    sensor: widget.sensor,
                    functions: [widget.function],
                    sliPid: widget.sliPid,
                    sliName: widget.sliName,
                    name: widget.name);
              });
        }, child: Obx(() {
          late List<double>? data;
          double change = 0;
          Color color = Colors.black;
          String name = "";
          if (auth.currentTab.value == 0) {
            if (widget.sliPid == "") {
              if (controller.nonSliSparklines.length <= 0) {
                data = [];
              } else {
                if ((controller.nonSliSparklines.last[widget.sensor.name ?? ""]
                            ?.length ??
                        0) <=
                    widget.index) {
                  data = [];
                } else {
                  data = controller.convertTimeSeriestoList(controller
                      .nonSliSparklines
                      .last[widget.sensor.name ?? ""]?[widget.index]
                      .getTimeSeries);

                  String stringColor = controller
                          .nonSliSparklines
                          .last[widget.sensor.name ?? ""]?[widget.index]
                          .getColor ??
                      '0000000';

                  color = new Color(
                      int.parse(stringColor.substring(1, 7), radix: 16) +
                          0xFF000000);

                  name = controller
                          .nonSliSparklines
                          .last[widget.sensor.name ?? ""]?[widget.index]
                          .getName ??
                      "";
                }
              }
            } else {
              if (controller.sliSparklines.length <= 0) {
                data = [];
              } else {
                if ((controller.sliSparklines.last[widget.sliPid]?.length ??
                        0) <=
                    widget.index) {
                  data = [];
                } else {
                  print("PID " + widget.sliPid);
                  print("NAME " +
                      controller.sliSparklines
                          .last[widget.sliPid]![widget.index].getName);
                  print("index " + widget.index.toString());
                  data = controller.convertTimeSeriestoList(controller
                      .sliSparklines
                      .last[widget.sliPid]?[widget.index]
                      .getTimeSeries);
                  String stringColor = controller.sliSparklines
                          .last[widget.sliPid]?[widget.index].getColor ??
                      '0000000';
                  color = new Color(
                      int.parse(stringColor.substring(1, 7), radix: 16) +
                          0xFF000000);
                  name = controller.sliSparklines
                          .last[widget.sliPid]?[widget.index].getName ??
                      "";
                }
              }
            }
            if (data == null || data.length < 1) {
              change = 0;
            } else if (data.length > 0) {
              //change = ((data[data.length - 1] - data[0]) / data.last * 100);
              change = ((data[data.length - 1] - data[0]));
            }
          } else {
            if (widget.sliPid == "") {
              if (controller.alertNonSliSparklines.length <= 0) {
                data = [];
              } else {
                if ((controller.alertNonSliSparklines
                            .last[widget.sensor.name ?? ""]?.length ??
                        0) <=
                    widget.index) {
                  data = [];
                } else {
                  data = controller.convertTimeSeriestoList(controller
                      .alertNonSliSparklines
                      .last[widget.sensor.name ?? ""]?[widget.index]
                      .getTimeSeries);
                  String stringColor = controller
                          .alertNonSliSparklines
                          .last[widget.sensor.name ?? ""]?[widget.index]
                          .getColor ??
                      '0000000';
                  color = new Color(
                      int.parse(stringColor.substring(1, 7), radix: 16) +
                          0xFF000000);
                  name = controller
                          .nonSliSparklines
                          .last[widget.sensor.name ?? ""]?[widget.index]
                          .getName ??
                      "";
                }
              }
            } else {
              if (controller.sliAlertSparklines.length <= 0) {
                data = [];
              } else {
                if (controller.sliAlertSparklines.last[widget.sliPid]!.length <=
                    widget.index) {
                  data = [];
                } else {
                  data = controller.convertTimeSeriestoList(controller
                      .sliAlertSparklines
                      .last[widget.sliPid]?[widget.index]
                      .getTimeSeries);
                  String stringColor = controller.sliAlertSparklines
                          .last[widget.sliPid]?[widget.index].getColor ??
                      '0000000';
                  color = new Color(
                      int.parse(stringColor.substring(1, 7), radix: 16) +
                          0xFF000000);
                  name = controller.nonSliSparklines
                          .last[widget.sliPid]?[widget.index].getName ??
                      "";
                }
              }
            }

            if (data == null || data.length < 1) {
              change = 0;
            } else if (data.length > 0) {
              //change = ((data[data.length - 1] - data[0]) / data.last * 100);
              change = ((data[data.length - 1] - data[0]));
            }
          }
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 4 / 100,
                vertical: MediaQuery.of(context).size.width * 4 / 100),
            child: Container(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          data == null
                              ? '-'
                              : (data.length) > 0
                                  ? data[data.length - 1].toStringAsFixed(2)
                                  : "-",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 4 / 100),
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 2 / 100),
                      Flexible(
                        //  width: MediaQuery.of(context).size.width * 12 / 100,
                        child: Text(
                            (change > 0 ? "+" : "") + change.toStringAsFixed(2),
                            //+  "%",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: change == 0
                                    ? Colors.blue.shade700
                                    : change > 0
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                fontSize: MediaQuery.of(context).size.width *
                                    3 /
                                    100)),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100,
                            child: Text(
                                widget.sliPid == ""
                                    ? widget.sensor.name ?? ""
                                    : widget.sliPid,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.75),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            3 /
                                            100))),
                        Text(name == "" ? '-' : name,
                            maxLines: 1,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.65),
                                fontSize: MediaQuery.of(context).size.width *
                                    2.5 /
                                    100)),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 1.5 / 100),
                  data == null
                      ? Expanded(
                          child: Container(
                              child: Text("No data",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.65)))))
                      : data.length == 0
                          ? Expanded(
                              child: Container(
                                  child: Center(
                              child: _connectionStatus ==
                                      ConnectivityResult.none
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              3 /
                                              100,
                                      child: FittedBox(
                                          child: Text("Error Loading Data")))
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              3 /
                                              100,
                                      width: MediaQuery.of(context).size.width *
                                          3 /
                                          100,
                                      child: CircularProgressIndicator()),
                            )))
                          : Expanded(
                              child: Sparkline(
                                  averageLine: false,
                                  averageLabel: false,
                                  lineColor: color,
                                  fillMode: FillMode.below,
                                  fillColor: color.withOpacity(
                                      (Theme.of(context).brightness ==
                                              Brightness.light
                                          ? 0.1
                                          : 0.4)),
                                  data: data))
                ],
              ),
            ),
          );
        })));
  }
}
