import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:pycnomobile/widgets/GraphBottomSheet.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/functionalities/GenericFunctionality.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/controllers/SensorInfoController.dart';

class SparklineCardV2 extends StatelessWidget {
  SparklineCardV2(
      {Key? key,
      required this.name,
      required this.function,
      required this.sli,
      required this.index,
      required this.sensor})
      : super(key: key);

  String name; //name of sensor
  Sensor sensor;
  int index;
  Functionality function;
  String sli;

  @override
  Widget build(BuildContext context) {
    SensorInfoController controller = Get.put(SensorInfoController());

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
                    sensor: sensor, functions: [function], sli: "", name: name);
              });
        }, child: Obx(() {
          List<double> data = sli == ""
              ? (controller.nonSliSparklines[sensor.name]?.length ?? 0) <= index
                  ? []
                  : controller.convertTimeSeriestoList(controller
                          .nonSliSparklines[sensor.name]?[index]
                          .getTimeSeries! ??
                      {})
              : (controller.sparkLines[sli]?.length ?? 0) <= index
                  ? []
                  : controller.convertTimeSeriestoList(
                      controller.sparkLines[sli]?[index].getTimeSeries! ?? {});

          late double change;

          change = data.length == 0
              ? 0
              : ((data[data.length - 1] - data[0]) / data[0] * 100);
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
                          (sli == ""
                                      ? function.value
                                      : sensor.sli?[sensor.sli?.indexWhere((e) {
                                            return e["PID"] == sli;
                                          }) ??
                                          0][function.key])
                                  .toStringAsFixed(3) ??
                              "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 4 / 100),
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 2 / 100),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 12 / 100,
                        child: Flexible(
                          child: Text(
                              (change > 0 ? "+" : "") +
                                  change.toStringAsFixed(1) +
                                  "%",
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
                        Text(sensor.name ?? "",
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
                  data.length == 0
                      ? Expanded(
                          child: Container(
                              child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CircularProgressIndicator())))
                      : Expanded(
                          // width: double.infinity,
                          // height: MediaQuery.of(context).size.width * 2.5 / 100,
                          child: Sparkline(
                              lineColor: change == 0
                                  ? Colors.blue.shade700
                                  : change > 0
                                      ? Colors.green.shade700.withOpacity(0.75)
                                      : Colors.red.shade700.withOpacity(0.75),
                              fillMode: FillMode.below,
                              fillColor: change == 0
                                  ? Colors.blue.shade700.withOpacity(
                                      (Theme.of(context).brightness ==
                                              Brightness.light
                                          ? 0.1
                                          : 0.4))
                                  : change > 0
                                      ? Colors.green.shade700.withOpacity(
                                          (Theme.of(context).brightness ==
                                                  Brightness.light
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
