import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

class SparklineListTile extends StatelessWidget {
  SparklineListTile(
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
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: InkWell(
            onTap: () {},
            child: ListTile(
              horizontalTitleGap: MediaQuery.of(context).size.width * 7.5 / 100,
              leading: Container(
                width: MediaQuery.of(context).size.width * 35 / 100,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 2 / 100,
                        child: FittedBox(
                            child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                        ))),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5 / 100,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 1.75 / 100,
                        child: FittedBox(
                            child: Text(
                          sli,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.75)),
                        ))),
                  ],
                ),
              ),
              title: SizedBox(
                height: MediaQuery.of(context).size.height * 2 / 100,
                child: Sparkline(
                  lineColor: change == 0
                      ? Colors.blue.shade700
                      : change > 0
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                  data: data,
                ),
              ),
              trailing: Container(
                //height: MediaQuery.of(context).size.height * 2 / 100,
                width: MediaQuery.of(context).size.width * 15 / 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 2 / 100,
                        child: FittedBox(
                            child: Text(data.last.toStringAsFixed(3)))),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5 / 100,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 1.75 / 100,
                        child: FittedBox(
                            child: Text((change).toStringAsFixed(3),
                                style: TextStyle(
                                    color: change == 0
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.75)
                                        : change > 0
                                            ? Colors.green.shade700
                                            : Colors.red.shade700)))),
                  ],
                ),
              ),
            )));
  }
}
