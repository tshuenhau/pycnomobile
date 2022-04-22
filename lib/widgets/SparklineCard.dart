import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:pycnomobile/widgets/GraphBottomSheet.dart';

class SparklineCard extends StatelessWidget {
  SparklineCard(
      {Key? key, required this.sli, required this.name, required this.data})
      : super(key: key);
  List<double> data;
  String sli;
  String name;

  @override
  Widget build(BuildContext context) {
    double change = (data.last - data.first);
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 4 / 100,
                vertical: MediaQuery.of(context).size.height * 2 / 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      data.last.toStringAsFixed(3),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              MediaQuery.of(context).size.width * 4 / 100),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 2 / 100),
                    Text((change > 0 ? "+" : "") + change.toStringAsFixed(3),
                        style: TextStyle(
                            color: change == 0
                                ? Colors.blue.shade700
                                : change > 0
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                            fontSize:
                                MediaQuery.of(context).size.width * 3 / 100)),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100,
                          child: Text(name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      3 /
                                      100))),
                      Text(sli,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width *
                                  2.5 /
                                  100)),
                    ],
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 1.5 / 100),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 4 / 100,
                  child: Sparkline(
                    lineColor: change == 0
                        ? Colors.blue.shade700
                        : change > 0
                            ? Colors.green.shade700.withOpacity(0.75)
                            : Colors.red.shade700.withOpacity(0.75),
                    fillMode: FillMode.below,
                    fillColor: change == 0
                        ? Colors.blue.shade700
                        : change > 0
                            ? Colors.green.shade700.withOpacity(0.1)
                            : Colors.red.shade700.withOpacity(0.1),
                    data: data,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
