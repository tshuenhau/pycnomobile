import 'package:flutter/material.dart';
import 'package:pycnomobile/model/Sensor.dart';
import 'package:pycnomobile/widgets/BasicSummaryCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pycnomobile/widgets/MultiSummaryCard.dart';

List<Widget> buildSummaryCards(Sensor sensor) {
  //!it takes as an argument the sensor that u clicked on
  List<Widget> leftColumn =
      []; //! this page layout is setup with a row of 2 columns
  List<Widget> rightColumn = [];
  //! heres the layout/ordering of the cards
  /*
  leftColumn  rightColumn
      1           2
      3           4
      5           6
 */
  void add(Widget card) {
    //! Adds to leftColumn, then rightColumn, then leftColumn, then rightColumn.
    if (leftColumn.isEmpty) {
      leftColumn.add(card);
    } else if (leftColumn.length <= rightColumn.length) {
      leftColumn.add(card);
    } else {
      rightColumn.add(card);
    }
  }

  //! The summary cards are below, the fomat is (icon, color, latest value, units). Think all u need to touch is the value part.
  //! The idea is to iterate a list or something then if there is that graph/function avail then instantiate this thing and change the value.
  //! add only if they exist for the sensor
  add(new BasicSummaryCard(
      icon: Icons.battery_charging_full, //Battery Voltage
      color: Colors.green,
      value: 17.55,
      unit: "dBm"));
  add(new BasicSummaryCard(
      icon: Icons.signal_cellular_alt, //Signal Strength
      color: Colors.purple,
      value: 17.55,
      unit: "°C"));
  add(new BasicSummaryCard(
      icon: Icons.thermostat, color: Colors.red, value: 17.55, unit: "°C"));
  add(new BasicSummaryCard(
      icon: FontAwesomeIcons.tint, // Relative Humidity
      color: Colors.blue,
      value: 17.55,
      unit: "RH%"));
  add(new BasicSummaryCard(
      icon: Icons.wb_sunny, // LUX
      color: Colors.orange,
      value: 17.55,
      unit: "LUX"));
  add(new BasicSummaryCard(
      icon: FontAwesomeIcons.radiationAlt, // Solar Radiation
      color: Colors.orange,
      value: 17.55,
      unit: "W/m2"));
  add(new BasicSummaryCard(
      icon: FontAwesomeIcons.cloudShowersHeavy, // Solar Radiation
      color: Colors.grey,
      value: 17.55,
      unit: "mm/h"));

  // summaryCards.add(
  //     new BlankBasicSummaryCard()); //! blank card just to make things look nicer for now, u can ignore this one.

//! below is the multi summary cards for soil moisture and temp its not 100% finished but u can use it alr. 1 thing im not sure about for this is the units especially the 10cm, 20cm part
  add(new MultiSummaryCard(
      title: "Soil Moisture",
      data: {
        "10cm": 58.53,
        "20cm": 59.22
      }, //! for this data part, the key value pair can be String:String, Stirng:Int, or ( Int: Int if the key does not come with the units, then ill have to add the units seperately or u can do it in ur api or smth)
      units: "mm")); // Soil Moisture
  add(new MultiSummaryCard(
      title: "Soil Temperature",
      data: {"10cm": 58.53, "20cm": 59.22},
      units: "ºC")); // Soil Temperature

  return [Column(children: leftColumn), Column(children: rightColumn)];
}
