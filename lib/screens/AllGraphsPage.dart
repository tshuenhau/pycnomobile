import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/controllers/TimeSeriesController.dart';
import 'package:pycnomobile/controllers/AuthController.dart';

class AllGraphsPage extends StatefulWidget {
  final Sensor sensor;
  const AllGraphsPage({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  @override
  State<AllGraphsPage> createState() => _AllGraphsPageState();
}

class _AllGraphsPageState extends State<AllGraphsPage> {
  AuthController auth = Get.find();
  late bool isAlert;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    if (auth.currentTab.value == 0) {
      print("IS SENSORS");
      isAlert = false;
    } else {
      print("IS ALERTS");
      isAlert = true;
    }
    initData(isAlert);
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initData(bool isAlert) async {
    await initGraphs(isAlert, widget.sensor, widget.sensor.functionalities!);
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
                await getGraphsForTimeRange(isAlert, _newDateRange,
                    widget.sensor, widget.sensor.functionalities!);
                //buildSensorGraphs(context, sensor, functions, _newDateRange);
              }
            },
            child: Icon(Icons.today,
                color: Theme.of(context).colorScheme.background)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // controller.initGraphs(sensor, sensor.functionalities!);

    return Center(
      child: Container(
        //padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width * 9.5 / 10,
        height: MediaQuery.of(context).size.height,
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 1 / 100),
        child: Align(
          alignment: Alignment.topCenter,
          child: Obx(
            () => ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [DateRangeSelector(context)],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 2.5 / 100,
                      ),
                    ] +
                    (!isAlert
                        ? buildGraphs(widget.sensor,
                            widget.sensor.functionalities!, context)
                        : buildAlertGraphs(widget.sensor,
                            widget.sensor.functionalities!, context))),
          ),
        ),
      ),
    );
  }
}
