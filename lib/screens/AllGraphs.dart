import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/controllers/TimeSeriesController.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/theme/GlobalTheme.dart';

class AllGraphs extends StatefulWidget {
  final Sensor sensor;
  const AllGraphs({Key? key, required this.sensor}) : super(key: key);

  @override
  State<AllGraphs> createState() => _AllGraphsState();
}

class _AllGraphsState extends State<AllGraphs> {
  List<TimeSeries> graphs = [];
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    graphs =
        await buildSensorGraphs(widget.sensor, widget.sensor.functionalities!);
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
                  lastDate: DateTime(3000));

              if (_newDateRange != null) {
                List<TimeSeries>? result = await getGraphsForTimeRange(
                    _newDateRange,
                    widget.sensor,
                    widget.sensor.functionalities!);
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
    return Center(
        child: Container(
            //padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width * 9.5 / 10,
            height: MediaQuery.of(context).size.height,
            child: Align(
              alignment: Alignment.topLeft,
              child: Obx(
                () => ListView(
                  children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    4.5 /
                                    100),
                            DateRangeSelector(context)
                          ],
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 2.5 / 100,
                        )
                      ] +
                      buildGraphs(context),
                ),
              ),
            )));
  }
}