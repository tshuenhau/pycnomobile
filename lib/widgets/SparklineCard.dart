import 'package:Sensr/model/TimeSeries.dart';
import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:Sensr/widgets/GraphBottomSheet.dart';
import 'package:Sensr/model/sensors/Sensor.dart';
import 'package:Sensr/model/functionalities/GenericFunctionality.dart';
import 'package:Sensr/model/functionalities/Functionality.dart';
import 'package:get/get.dart';
import 'package:Sensr/controllers/SensorInfoController.dart';
import 'package:Sensr/controllers/AuthController.dart';
import 'package:collection/collection.dart';

class SparklineCard extends StatelessWidget {
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
                    sensor: sensor,
                    functions: [function],
                    sliPid: sliPid,
                    sliName: sliName,
                    name: name);
              });
        }, child: Obx(() {
          late List<double>? data;
          double change = 0;

          if (auth.currentTab.value == 0) {
            if (sliPid == "") {
              if (controller.nonSliSparklines.length <= 0) {
                data = [];
              } else {
                if ((controller
                            .nonSliSparklines.last[sensor.name ?? ""]?.length ??
                        0) <=
                    index) {
                  data = [];
                } else {
                  data = controller.convertTimeSeriestoList(controller
                      .nonSliSparklines
                      .last[sensor.name ?? ""]?[index]
                      .getTimeSeries);
                }
              }
            } else {
              if (controller.sparkLines.length == 0) {
                data = [];
              } else {
                data = controller.convertTimeSeriestoList(controller
                    .sparkLines.last[sensor.name ?? ""]?[index].getTimeSeries);
              }
            }
            if (data == null || data.length < 1) {
              change = 0;
            } else if (data.length > 0) {
              double average = data.average;
              //change = ((data[data.length - 1] - data[0]) / data.last * 100);
              change = ((data[data.length - 1] - data[0]));
            }
          } else {
            if (sliPid == "") {
              if (controller.alertNonSliSparklines.length <= 0) {
                data = [];
              } else {
                if ((controller.alertNonSliSparklines.last[sensor.name ?? ""]
                            ?.length ??
                        0) <=
                    index) {
                  data = [];
                } else {
                  data = controller.convertTimeSeriestoList(controller
                      .alertNonSliSparklines
                      .last[sensor.name ?? ""]?[index]
                      .getTimeSeries);
                }
              }
            } else {
              if (controller.alertSparklines.length <= 0) {
                data = [];
              } else {
                if (controller
                        .alertSparklines.last[sensor.name ?? ""]!.length <=
                    index) {
                  data = [];
                } else {
                  data = controller.convertTimeSeriestoList(controller
                      .alertNonSliSparklines
                      .last[sensor.name ?? ""]?[index]
                      .getTimeSeries);
                }
              }
            }

            if (data == null || data.length < 1) {
              change = 0;
            } else if (data.length > 0) {
              double average = data.average;
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
                            child: Text(function.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.75),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            3 /
                                            100))),
                        Text(function.name,
                            style: TextStyle(
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
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.width *
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
                                  lineColor: change == 0
                                      ? Colors.blue.shade700
                                      : change > 0
                                          ? Colors.green.shade700
                                              .withOpacity(0.75)
                                          : Colors.red.shade700
                                              .withOpacity(0.75),
                                  fillMode: FillMode.below,
                                  fillColor: change == 0
                                      ? Colors.blue.shade700.withOpacity(
                                          (Theme.of(context).brightness == Brightness.light
                                              ? 0.1
                                              : 0.4))
                                      : change > 0
                                          ? Colors.green.shade700.withOpacity(
                                              (Theme.of(context).brightness == Brightness.light
                                                  ? 0.1
                                                  : 0.4))
                                          : Colors.red.shade700.withOpacity(
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
