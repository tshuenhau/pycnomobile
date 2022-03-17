import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/model/TimeSeries.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/controllers/TimeSeriesController.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initData();
    });
  }

  void initData() async {
    await initGraphs(widget.sensor, widget.sensor.functionalities!);
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
                await getGraphsForTimeRange(_newDateRange, widget.sensor,
                    widget.sensor.functionalities!);
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
    print("HEELLO");
    TimeSeriesController controller = Get.put(TimeSeriesController());

    // controller.initGraphs(sensor, sensor.functionalities!);
    return Center(
        child: Container(
            //padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width * 9.5 / 10,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 1 / 100),
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
                          height:
                              MediaQuery.of(context).size.height * 2.5 / 100,
                        ),
                      ] +
                      buildGraphs(widget.sensor, widget.sensor.functionalities!,
                          context),
                ),
              ),
            )));
  }
}
// class AllGraphsPage extends StatefulWidget {
//   final Sensor sensor;
//   const AllGraphsPage({
//     Key? key,
//     required this.sensor,
//   }) : super(key: key);

//   @override
//   State<AllGraphsPage> createState() => _AllGraphsPageState();
// }

// class _AllGraphsPageState extends State<AllGraphsPage> {
//   @override
//   void initState() {
//     super.initState();
//     initData();
//   }

//   void initData() async {
//     await initGraphs(widget.sensor, widget.sensor.functionalities!);
//   }

//   Widget DateRangeSelector(BuildContext context) {
//     return Theme(
//       data: ThemeData(
//           colorScheme: Theme.of(context).colorScheme.copyWith(
//               primary: Theme.of(context).colorScheme.secondary,
//               secondary: Theme.of(context).colorScheme.primary)),
//       child: Builder(
//         builder: (context) => ElevatedButton(
//             onPressed: () async {
//               DateTimeRange? _newDateRange = await showDateRangePicker(
//                   context: context,
//                   firstDate: DateTime(1800),
//                   lastDate: DateTime.now());

//               if (_newDateRange != null) {
//                 List<TimeSeries>? result = await getGraphsForTimeRange(
//                     _newDateRange,
//                     widget.sensor,
//                     widget.sensor.functionalities!);
//                 //buildSensorGraphs(context, sensor, functions, _newDateRange);
//               }
//             },
//             child: Icon(Icons.today,
//                 color: Theme.of(context).colorScheme.background)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("HEELLO");
//     return Center(
//         child: Container(
//             //padding: EdgeInsets.symmetric(horizontal: 20),
//             width: MediaQuery.of(context).size.width * 9.5 / 10,
//             height: MediaQuery.of(context).size.height,
//             padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).size.height * 1 / 100),
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Obx(
//                 () => ListView(
//                   padding: EdgeInsets.all(0),
//                   children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [DateRangeSelector(context)],
//                         ),
//                         SizedBox(
//                           height:
//                               MediaQuery.of(context).size.height * 2.5 / 100,
//                         ),
//                       ] +
//                       buildGraphs(
//                         widget.sensor.functionalities!,
//                       ),
//                 ),
//               ),
//             )));
//   }
// }
