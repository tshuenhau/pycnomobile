import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/widgets/SummaryCard.dart';

class BasicSummaryCard extends StatelessWidget {
  final Sensor sensor;
  final Functionality function;

  const BasicSummaryCard(
      {Key? key, required this.sensor, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SummaryCard(
      sensor: sensor,
      functions: [function],
      child: Container(
          width: MediaQuery.of(context).size.width * 1 / 2 - 20,
          height: MediaQuery.of(context).size.height * 1 / 8 - 10,
          child: Center(
            child: Row(children: [
              SizedBox(width: MediaQuery.of(context).size.width * 3.5 / 100),
              Icon(
                function.icon ?? Icons.help_center_outlined,
                size: MediaQuery.of(context).size.width * 9 / 100,
                color: function.color ?? Colors.black,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 2 / 100),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 20 / 100,
                    child: AutoSizeText(
                      function.value?.toStringAsFixed(2) ?? "-",
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      minFontSize: 20,
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 10 / 100,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 1 / 100),
                      child: AutoSizeText(
                        " " + function.unit,
                        maxLines: 1,
                        minFontSize: 1,
                        textAlign: TextAlign.left,
                      )),
                ],
              ),
              //trailing: Text(" °C")
            ]),
          )),
    );
  }
}
