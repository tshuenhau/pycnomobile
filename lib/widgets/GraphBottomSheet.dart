import 'package:flutter/material.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';

class GraphBottomSheet extends StatelessWidget {
  const GraphBottomSheet({Key? key, required this.graphs}) : super(key: key);
  final List<TimeSeries> graphs;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 2.5 / 100),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              //topRight: const Radius.circular(10.0)
            )),
        height: MediaQuery.of(context).size.height * 60 / 100,
        child: Center(
            child: ListView(
          // ! here we do a isLoaded? buildGraphs : loading widget
          children: buildGraphs(context),
        )));
  }

  List<Widget> buildGraphs(BuildContext context) {
    List<Widget> graphsToDraw = [];

    graphsToDraw.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Selected Date"),
        ElevatedButton(
            onPressed: () async {
              DateTimeRange? _newDateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(1800),
                  lastDate: DateTime(3000));
              Navigator.pop(context);
              print(_newDateRange); //!graphBuilder with new dates
            },
            child: Icon(Icons.today)),
        SizedBox(height: MediaQuery.of(context).size.height * 2 / 100)
      ],
    ));
    graphs.forEach((e) => {
          graphsToDraw.add(
              SensorLineChart(data: e.getTimeSeries, functionName: e.getKey))
        });
    // graphs.forEach((key, value) {
    //   graphsToDraw.add(SensorLineChart(data: value, function: key));
    // });
    return graphsToDraw;
  }
}
