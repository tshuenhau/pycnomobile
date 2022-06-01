// import 'package:flutter/material.dart';
// import 'package:Sensr/builders/SensorGraphsBuilder.dart';
// import 'package:Sensr/model/TimeSeries.dart';
// import 'package:Sensr/theme/Theme.of(context).dart';

// Widget DateRangeSelector(BuildContext context) {
//   return Theme(
//     data: ThemeData(
//         colorScheme: Theme.of(context).colorScheme.copyWith(
//             primary: Theme.of(context).colorScheme.secondary,
//             secondary: Theme.of(context).colorScheme.primary)),
//     child: Builder(
//       builder: (context) => ElevatedButton(
//           onPressed: () async {
//             DateTimeRange? _newDateRange = await showDateRangePicker(
//                 context: context,
//                 firstDate: DateTime(1800),
//                 lastDate: DateTime(3000));

//             if (_newDateRange != null) {
//               List<TimeSeries>? result = await getGraphsForTimeRange(
//                   _newDateRange, widget.sensor, widget.functions);
//               setState(() {
//                 graphs = result!;
//               });

//               //buildSensorGraphs(context, sensor, functions, _newDateRange);
//             }
//           },
//           child: Icon(Icons.today)),
//     ),
//   );
// }
