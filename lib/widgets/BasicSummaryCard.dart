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
          height: MediaQuery.of(context).size.height * 1 / 7 - 10,
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                child: function.icon == null
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 1 / 100,
                            right: MediaQuery.of(context).size.width * 1 / 100,
                            bottom:
                                MediaQuery.of(context).size.height * 1 / 100),
                        child: AutoSizeText(
                          function.name == null ? function.key : function.name,
                          style: TextStyle(),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          minFontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).size.height * 1 / 100),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 10 / 100,
                          width: MediaQuery.of(context).size.width * 10 / 100,
                          child: FittedBox(
                            child: Icon(
                              function.icon ?? Icons.help_center_outlined,
                              size: MediaQuery.of(context).size.width * 9 / 100,
                              color: function.color ?? Colors.black,
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 25 / 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                        function.unit,
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
