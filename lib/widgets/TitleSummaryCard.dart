import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/widgets/SummaryCard.dart';

class TitleSummaryCard extends StatelessWidget {
  final Sensor sensor;
  final Functionality function;
  const TitleSummaryCard(
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
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(width: MediaQuery.of(context).size.width * 3.5 / 100),
              SizedBox(
                width: MediaQuery.of(context).size.width * 10 / 100,
                child: FittedBox(
                  child: Icon(
                    function.icon ?? Icons.help_center_outlined,
                    size: MediaQuery.of(context).size.width * 9 / 100,
                    color: function.color ?? Colors.black,
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 5 / 100),
              SizedBox(
                width: MediaQuery.of(context).size.width * 25 / 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      function.value?.toStringAsFixed(2) ?? "-",
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      minFontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.25 / 100),
                      child: AutoSizeText(
                        function.unit!,
                        maxLines: 1,
                        minFontSize: 1,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              //trailing: Text(" °C")
            ]),
          )),
    );
  }
}
