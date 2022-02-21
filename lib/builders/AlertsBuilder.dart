import 'package:flutter/material.dart';
import 'package:pycnomobile/widgets/AlertListTile.dart';

List<Widget> buildAlerts() {
  /*
  api here : https://stage.pycno.co/api/v2/notifications.json?TK=fGXiDK9cnC52V3uaBLLg1G7l4LodjyX4&UID=M2DBCBCC1A31A19D5&S2T
  minimum needed for Notification class
   Notification{
    String/int/double/wtv notificationId;
    Sensor sensor; // need to match UID from api call and get the exact sensor
    String description;
    NotificationType type; // the NotificationType should contain an Icon field also. so i can put battery icon/frost icon
    DateTime timeAgo;//can be in epochs or wtv
    int state;
    int severity;
   }

  - need some global counter to get total number of notification with severity> 0 and state == 0 to show how many notifs total ( its for the "number of alerts" badge on bottomnavbar)
  - also need a global function/boolean to tell if there is any notification with severity > 3 and state == 0
  - the AlertListTile class is not updated to accept Notification class yet.
  - Once u build the api call to get List<Notification> then u can stop alr, ill handle the rest.
  - Actually we kinda need to call this api right at the start of the app launching so I can put the total number of notifications on the bottom nav bar
  - This api i guess should run parallel with the sensorlist api at the start
  Basically we need a List<Notification> which we iterate and build a List<AlertListTile>, then we gucci

   */

  //call function to get all notifications then return the list of AlertListTile

  List<AlertListTile> alerts = [];
  return [
    // AlertListTile(
    //     icon: Icon(Icons.ac_unit), // based on event_frost/event_low_battery
    //     notificationId: "840995",
    //     sensor: ,
    //     description: "Temperature is below 2ºC. High frost probability.",
    //     timeAgo: "4 hours ago"),
    // AlertListTile(
    //     icon: Icon(Icons.battery_alert),
    //     notificationId: "840995",
    //     sensor:,
    //     description: "Battery is below 10%.",
    //     timeAgo: "4 hours ago"),
  ];
}
