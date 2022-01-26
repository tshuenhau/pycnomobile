import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SensorGraphsBuilder.dart';
import 'package:pycnomobile/model/Sensor.dart';
import 'package:pycnomobile/model/MasterSoilSensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';
import 'package:pycnomobile/widgets/BasicSummaryCard.dart';
import 'package:pycnomobile/widgets/MultiSummaryCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pycnomobile/widgets/SensorLineChart.dart';

List<Widget> buildSummaryCards(
    {required Sensor sensor, required BuildContext context}) {
  List<Widget> leftColumn = [];
  List<Widget> rightColumn = [];
  /*
  leftColumn  rightColumn
      1           2
      3           4
      5           6
 */
  void add(Widget card) {
    if (leftColumn.isEmpty) {
      leftColumn.add(card);
    } else if (leftColumn.length <= rightColumn.length) {
      leftColumn.add(card);
    } else {
      rightColumn.add(card);
    }
  }

  if (sensor.functionalities != null) {
    for (Functionality func in sensor.functionalities!) {
      if (func.value is List<Functionality>) {
        add(new MultiSummaryCard(
            //! Maybeb do a check here? for whether the stuff in List<Functionality> has a graph or not
            data: Map.fromIterable(func.value,
                key: (e) => e.name, value: (e) => e.value),
            sensor: sensor,
            function: func,
            functions: func.value));
      } else {
        add(new BasicSummaryCard(
            //TODO: Refactor these stuff especially the func.icon, func.color bs, just pass one func is enough.
            sensor: sensor,
            function: func));
      }
    }
  }

  /* many ways to do it but could be somthing like
  Loop through a list of functions:
    if(isTemperatureFunction) {
      add(new BasicSummaryCard(
        icon: Icons.thermostat, // Temperature
        color: Colors.red,
        value: 17.55,
        unit: "°C"));
    }
    else if(isBatteryFunction) {
      add(new BasicSummaryCard(
        icon: Icons.battery_charging_full, //Battery Voltage
        color: Colors.green,
        value: 17.55,
        unit: "dBm"));
    }
   */
//   add(new BasicSummaryCard(
//       icon: Icons.battery_charging_full, //Battery Voltage
//       color: Colors.green,
//       value: 17.55,
//       unit: "dBm"));
//   add(new BasicSummaryCard(
//       icon: Icons.signal_cellular_alt, //Signal Strength
//       color: Colors.purple,
//       value: 17.55,
//       unit: "°C"));
//   add(new BasicSummaryCard(
//       icon: Icons.thermostat, // Temperature
//       color: Colors.red,
//       value: 17.55,
//       unit: "°C"));
//   add(new BasicSummaryCard(
//       icon: FontAwesomeIcons.tint, // Relative Humidity
//       color: Colors.blue,
//       value: 17.55,
//       unit: "RH%"));
//   add(new BasicSummaryCard(
//       icon: Icons.wb_sunny, // LUX
//       color: Colors.orange,
//       value: 17.55,
//       unit: "LUX"));
//   add(new BasicSummaryCard(
//       icon: FontAwesomeIcons.radiationAlt, // Solar Radiation
//       color: Colors.orange,
//       value: 17.55,
//       unit: "W/m2"));
//   add(new BasicSummaryCard(
//       icon: FontAwesomeIcons.cloudShowersHeavy, // Solar Radiation
//       color: Colors.grey,
//       value: 17.55,
//       unit: "mm/h"));

// //! below is the multi summary cards for soil moisture and temp, its more complicated but u can try use it. If too hard then we need discuss how to design it alr.
// //! 1 thing im not sure about for this is the units especially the 10cm, 20cm part. But if u have no prob using it as is it will b gud.
//   add(new MultiSummaryCard(
//       title: "Soil Moisture",
//       data: {
//         "10cm": 58.53,
//         "20cm": 59.22
//       }, //! for this data part, the key value pair can be String:String, Stirng:Int, or ( Int: Int if the key does not come with the units, then ill have to add the units seperately or u can do it in ur api or smth)
//       units: "mm")); // Soil Moisture
//   add(new MultiSummaryCard(
//       title: "Soil Temperature",
//       data: {"10cm": 58.53, "20cm": 59.22},
//       units: "ºC")); // Soil Temperature

  return [Column(children: leftColumn), Column(children: rightColumn)];
}
