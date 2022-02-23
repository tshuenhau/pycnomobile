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
  final List<Functionality?> functions;

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

  Widget DateRangeSelector(BuildContext context) {
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
                  lastDate: DateTime.now());

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
    TimeSeriesController controller = Get.put(TimeSeriesController());

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
      height: controller.countNumberOfGraphs(widget.functions) > 1
          ? MediaQuery.of(context).size.height * 75 / 100
          : MediaQuery.of(context).size.height * 55 / 100,
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
                      DateRangeSelector(context)
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 2.5 / 100,
                  )
                ] +
                buildGraphs(context, widget.functions),
          ),
        ),
      ),
    );
  }
}
