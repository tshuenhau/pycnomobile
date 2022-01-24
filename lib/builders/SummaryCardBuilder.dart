import 'package:flutter/material.dart';
import 'package:pycnomobile/model/Sensor.dart';
import 'package:pycnomobile/widgets/BasicSummaryCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pycnomobile/widgets/MultiSummaryCard.dart';

List<Widget> buildSummaryCards(Sensor sensor) {
  // !it takes in the sensor that u clicked on
  //! Logic to build summary cards here

  List<Widget> summaryCards = [];
  //! The summary cards are below, the fomat is (icon, color, latest value, units). Think all u need to touch is the value part.
  //! The idea is to iterate a list or something then if there is that graph/function avail then instantiate this thing and change the value.
  //! do summaryCards.add only if they exist for the sensor
  summaryCards.add(new BasicSummaryCard(
      icon: Icons.battery_charging_full, //Battery Voltage
      color: Colors.green,
      value: 17.55,
      unit: "dBm"));
  summaryCards.add(new BasicSummaryCard(
      icon: Icons.signal_cellular_alt, //Signal Strength
      color: Colors.purple,
      value: 17.55,
      unit: "°C"));
  summaryCards.add(new BasicSummaryCard(
      icon: Icons.thermostat, color: Colors.red, value: 17.55, unit: "°C"));
  summaryCards.add(new BasicSummaryCard(
      icon: FontAwesomeIcons.tint, // Relative Humidity
      color: Colors.blue,
      value: 17.55,
      unit: "RH%"));
  summaryCards.add(new BasicSummaryCard(
      icon: Icons.wb_sunny, // LUX
      color: Colors.orange,
      value: 17.55,
      unit: "LUX"));
  summaryCards.add(new BasicSummaryCard(
      icon: FontAwesomeIcons.radiationAlt, // Solar Radiation
      color: Colors.orange,
      value: 17.55,
      unit: "W/m2"));

//! below is the multi summary cards for soil moisture and temp its not 100% finished but u can use it alr. 1 thing im not sure about for this is the units especially the 10cm, 20cm part
  summaryCards.add(new MultiSummaryCard(
      title: "Soil Moisture",
      data: {
        "10cm": 58.53,
        "20cm": 59.22
      }, //! for this data part, the key value pair can be String:String, Stirng:Int, or ( Int: Int if the key does not come with the units, then ill have to add the units seperately or u can do it in ur api or smth)
      units: "mm")); // Soil Moisture
  summaryCards.add(new MultiSummaryCard(
      title: "Soil Temperature",
      data: {"10cm": 58.53, "20cm": 59.22},
      units: "ºC")); // Soil Temperature

  return summaryCards;
}
