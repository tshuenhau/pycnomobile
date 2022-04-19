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
                width: MediaQuery.of(context).size.width * 50 / 100,
                alignment: Alignment.centerLeft,
                child: Text(
                  name + " " + sli,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              title: SizedBox(
                width: 5.0,
                height: 20,
                child: Sparkline(
                  data: data,
                ),
              ),
              trailing: Text(data.last.toString()),
            )));
  }
}
