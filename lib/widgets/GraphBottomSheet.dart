import 'package:flutter/material.dart';
import 'package:Sensr/builders/SensorGraphsBuilder.dart';
import 'package:Sensr/model/TimeSeries.dart';
import 'package:Sensr/model/functionalities/Functionality.dart';
import 'package:Sensr/model/sensors/Sensor.dart';
import 'package:Sensr/theme/customColorScheme.dart';
import 'package:Sensr/widgets/SensorLineChart.dart';
import 'package:Sensr/controllers/TimeSeriesController.dart';
import 'package:Sensr/controllers/AuthController.dart';
import 'package:get/get.dart';

class GraphBottomSheet extends StatefulWidget {
  GraphBottomSheet(
      {Key? key,
      required this.sensor,
      required this.functions,
      required this.sliPid,
      required this.sliName,
      required this.name})
      : super(key: key);
  final Sensor sensor;
  final String sliPid;
  final String sliName;
  final String name;
  final List<Functionality?> functions;

  @override
  State<GraphBottomSheet> createState() => _GraphBottomSheetState();
}

class _GraphBottomSheetState extends State<GraphBottomSheet> {
  late bool isAlert;
  AuthController auth = Get.find();
  @override
  void initState() {
    super.initState();
    if (auth.currentTab.value == 0) {
      isAlert = false;
    } else {
      isAlert = true;
    }

    initData();
  }

  void initData() async {
    await initGraphs(isAlert, widget.sensor, widget.functions, widget.sliPid,
        widget.sliName, widget.name);
  }

  @override
  void dispose() {
    super.dispose();
    // graphs.clear();
  }

  Widget DateRangeSelector(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.secondary,
              secondary: Theme.of(context).colorScheme.primary)),
      child: Builder(
          builder: (context) => ElevatedButton(
              onPressed: () async {
                DateTimeRange? _newDateRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(1800),
                    lastDate: DateTime.now());

                if (_newDateRange != null) {
                  await getGraphsForTimeRange(
                      isAlert,
                      _newDateRange,
                      widget.sensor,
                      widget.functions,
                      widget.sliPid,
                      widget.sliName,
                      widget.name);
                }
              },
              child: Icon(Icons.today,
                  color: Theme.of(context).colorScheme.background))),
    );
  }

  @override
  Widget build(BuildContext context) {
    TimeSeriesController controller = Get.put(TimeSeriesController());
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 2.5 / 100),
      decoration: new BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0)
              //topRight: const Radius.circular(10.0)
              )),
      height: MediaQuery.of(context).size.height * 55 / 100,
      child: Center(
        child: Obx(
          () => ListView(
              children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width:
                                MediaQuery.of(context).size.width * 4.5 / 100),
                        DateRangeSelector(context)
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 2.5 / 100,
                    )
                  ] +
                  buildGraphs(
                      sensor: widget.sensor,
                      functions: widget.functions,
                      type: widget.sliPid == ""
                          ? TYPE_OF_TIMESERIES.SINGLE_INTERNAL
                          : TYPE_OF_TIMESERIES.SINGLE_SLI,
                      context: context,
                      isAlert: isAlert)),
        ),
      ),
    );
  }
}
