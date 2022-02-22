import 'package:flutter/material.dart';
import 'package:pycnomobile/model/NotificationData.dart';
import 'package:pycnomobile/widgets/AlertListTile.dart';
import 'package:pycnomobile/controllers/NotificationsController.dart';
import 'package:get/get.dart';

List<Widget> buildAlerts() {
  NotificationsController controller = Get.put(NotificationsController());
  controller.getNotifications();

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

  - need some global counter to get total number of notification with severity> 0 and state == 0 to show how many notifs total ( its for the "number of alerts" badge on bottomnavbar) (ZQ: controller.alertCount)
  - also need a global function/boolean to tell if there is any notification with severity > 3 and state == 0 (ZQ: controller.isSevere)
  - the AlertListTile class is not updated to accept Notification class yet.
  - Once u build the api call to get List<Notification> then u can stop alr, ill handle the rest.
  - Actually we kinda need to call this api right at the start of the app launching so I can put the total number of notifications on the bottom nav bar
  - This api i guess should run parallel with the sensorlist api at the start
  Basically we need a List<Notification> which we iterate and build a List<AlertListTile>, then we gucci

   */

  //call function to get all notifications then return the list of AlertListTile
  List<AlertListTile> alerts = [];

  print("number of notifs: " + controller.notifications.length.toString());
  controller.notifications.forEach((e) {
    print(e.desc);
    alerts.add(AlertListTile(notification: e));
  });
  return alerts;
}
