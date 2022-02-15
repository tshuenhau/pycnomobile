import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/theme/CustomColorScheme.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';
import 'package:pycnomobile/controllers/TimeSeriesController.dart';
import 'package:get/get.dart';
import '../theme/GlobalTheme.dart';

class GraphBottomSheet extends StatefulWidget {
  GraphBottomSheet({Key? key, required this.sensor, required this.functions})
      : super(key: key);
  final Sensor sensor;
  final List<Functionality> functions;

  @override
  State<GraphBottomSheet> createState() => _GraphBottomSheetState();
}

class _GraphBottomSheetState extends State<GraphBottomSheet> {
  //late DateTimeRange? dateRange;
  List<TimeSeries> graphs = [];
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    graphs = await buildSensorGraphs(widget.sensor, widget.functions);
  }

  @override
  void dispose() {
    super.dispose();
    graphs.clear();
  }

  List<Widget> buildGraphs(BuildContext context) {
    TimeSeriesController controller = Get.find();
    List<Widget> graphsToDraw = <Widget>[];
    graphsToDraw.clear();
    if (controller.graphs.length <= 0) {
      graphsToDraw.add(Center(child: Text("No data for selected time period")));
    }
    controller.graphs.forEach((e) => {
          graphsToDraw.add(SensorLineChart(
              key: UniqueKey(), data: e.getTimeSeries, functionName: e.getKey))
        });
    // graphs.forEach((key, value) {
    //   graphsToDraw.add(SensorLineChart(data: value, function: key));
    // });
    return graphsToDraw;
  }

  Widget returnRangePicker(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme: globalTheme.colorScheme.copyWith(
              primary: globalTheme.colorScheme.secondary,
              secondary: globalTheme.colorScheme.primary)),
      child: Builder(
        builder: (context) => ElevatedButton(
            onPressed: () async {
              DateTimeRange? _newDateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(1800),
                  lastDate: DateTime(3000));

              if (_newDateRange != null) {
                List<TimeSeries>? result = await getGraphsForTimeRange(
                    _newDateRange, widget.sensor, widget.functions);
                setState(() {
                  graphs = result!;
                });

                //buildSensorGraphs(context, sensor, functions, _newDateRange);
              }
            },
            child: Icon(Icons.today)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 2.5 / 100),
      decoration: new BoxDecoration(
          color: globalTheme.colorScheme.background,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0)
              //topRight: const Radius.circular(10.0)
              )),
      height: graphs.length > 1
          ? MediaQuery.of(context).size.height * 75 / 100
          : MediaQuery.of(context).size.height * 50 / 100,
      child: Center(
        child: Obx(
          () => ListView(
            children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 4.5 / 100),
                      returnRangePicker(context)
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 2.5 / 100,
                  )
                ] +
                buildGraphs(context),
          ),
        ),
      ),
    );
  }
}
