import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';

class GraphBottomSheet extends StatefulWidget {
  GraphBottomSheet(
      {Key? key,
      required this.graphs,
      required this.sensor,
      required this.functions})
      : super(key: key);
  List<TimeSeries> graphs;
  final Sensor sensor;
  final List<Functionality> functions;

  @override
  State<GraphBottomSheet> createState() => _GraphBottomSheetState();
}

class _GraphBottomSheetState extends State<GraphBottomSheet> {
  //late DateTimeRange? dateRange;
  List<TimeSeries> graphs = [];
  List<Widget> graphsToDraw = <
      Widget>[]; //! I think its because the number of widgets and the type remains the same so it does not update. Printing this gives: [SensorLineChart].
  //!So even if SensorLineChart changes, from the perspective of statemanagemnt it does not change
  //! Might need to wrap this in ChangeNotifier then when the graphs get updated and api gets recalled we notifylistners.

  @override
  void initState() {
    super.initState();
    graphsToDraw = buildGraphs(context, widget.graphs);
  }

  @override
  void dispose() {
    super.dispose();
    graphs.clear();
    graphsToDraw.clear();
  }

  List<Widget> buildGraphs(BuildContext context, List<TimeSeries> graphs) {
    graphsToDraw.clear();

    if (graphs.length <= 0) {
      graphsToDraw.add(Center(child: Text("No data for selected time period")));
    }
    graphs.forEach((e) => {
          graphsToDraw.add(SensorLineChart(
              key: UniqueKey(), data: e.getTimeSeries, functionName: e.getKey))
        });
    // graphs.forEach((key, value) {
    //   graphsToDraw.add(SensorLineChart(data: value, function: key));
    // });
    return graphsToDraw;
  }

  void refresh(List<TimeSeries> graphs) {
    setState(() {
      graphsToDraw = buildGraphs(context, graphs);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(graphsToDraw);
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 2.5 / 100),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              //topRight: const Radius.circular(10.0)
            )),
        height: graphs.length > 1
            ? MediaQuery.of(context).size.height * 75 / 100
            : MediaQuery.of(context).size.height * 50 / 100,
        child: Center(
            child: ListView(
          children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 4.5 / 100),
                    ElevatedButton(
                        onPressed: () async {
                          DateTimeRange? _newDateRange =
                              await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(1800),
                                  lastDate: DateTime(3000));
                          if (_newDateRange != null) {
                            List<TimeSeries>? result =
                                await getGraphsForTimeRange(_newDateRange,
                                    widget.sensor, widget.functions);
                            setState(() {
                              graphs = result!;
                            });
                            refresh(graphs);

                            //buildSensorGraphs(context, sensor, functions, _newDateRange);
                          }
                        },
                        child: Icon(Icons.today)),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 2.5 / 100,
                )
              ] +
              graphsToDraw,
        )));
  }
}
