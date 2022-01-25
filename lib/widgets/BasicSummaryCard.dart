import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BasicSummaryCard extends StatelessWidget {
  final IconData icon;
  final double? value;
  final String unit;
  final Color color;
  const BasicSummaryCard(
      {Key? key,
      required this.icon,
      required this.color,
      required this.value,
      required this.unit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: () => {},
          child: Container(
              width: MediaQuery.of(context).size.width * 1 / 2 - 20,
              height: MediaQuery.of(context).size.height * 1 / 8 - 10,
              child: Center(
                child: Row(children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 3.5 / 100),
                  Icon(
                    icon,
                    size: MediaQuery.of(context).size.width * 9 / 100,
                    color: color,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 2 / 100),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 20 / 100,
                        child: AutoSizeText(
                          value?.toStringAsFixed(2) ?? "-",
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          minFontSize: 20,
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 10 / 100,
                          padding: EdgeInsets.only(
                              top:
                                  MediaQuery.of(context).size.height * 1 / 100),
                          child: AutoSizeText(
                            " " + unit,
                            maxLines: 1,
                            minFontSize: 1,
                            textAlign: TextAlign.left,
                          )),
                    ],
                  ),
                  //trailing: Text(" °C")
                ]),
              )),
        ));
  }
}
