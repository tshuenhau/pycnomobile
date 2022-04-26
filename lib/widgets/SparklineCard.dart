import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:pycnomobile/widgets/GraphBottomSheet.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/functionalities/GenericFunctionality.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:get/get.dart';

class SparklineCard extends StatelessWidget {
  SparklineCard(
      {Key? key,
      required this.sli,
      required this.name,
      required this.function,
      required this.data,
      required this.sensor})
      : super(key: key);
  List<double> data;
  String sli; //sli pid
  String name; //name of sensor
  Sensor sensor;
  Functionality function;

  @override
  Widget build(BuildContext context) {
    double change = (data.last - data.first) / data.first * 100;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: () {
            print("NAME" + name + " SLI " + sli);
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return GraphBottomSheet(
                      sensor: sensor,
                      functions: [function],
                      sli: sli,
                      name: name);
                });
          },
          child: Padding(
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
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            data.last.toStringAsFixed(2) + "",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width *
                                    4 /
                                    100),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 2 / 100),
                        Text(
                            (change > 0 ? "+" : "") +
                                change.toStringAsFixed(2) +
                                "%",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: change == 0
                                    ? Colors.blue.shade700
                                    : change > 0
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                fontSize: MediaQuery.of(context).size.width *
                                    3.5 /
                                    100)),
                      ],
                    ),
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
                                name
                                    .replaceAll(
                                        new RegExp(r"\([^)]*\)", unicode: true),
                                        "")
                                    .replaceAll(
                                        new RegExp(r'[ ]{2,}', unicode: true),
                                        ' '),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.75),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            3 /
                                            100))),
                        Text(sli,
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
                  Expanded(
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
                          ? Colors.blue.shade700.withOpacity(0.1)
                          : change > 0
                              ? Colors.green.shade700.withOpacity(0.1)
                              : Colors.red.shade700.withOpacity(0.1),
                      data: data,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
