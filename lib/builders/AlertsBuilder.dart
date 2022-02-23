import 'package:flutter/material.dart';
import 'package:pycnomobile/model/NotificationData.dart';
import 'package:pycnomobile/widgets/AlertListTile.dart';
import 'package:pycnomobile/controllers/NotificationsController.dart';
import 'package:get/get.dart';

List<Widget> buildAlerts() {
  NotificationsController controller = Get.put(NotificationsController());
  // controller.getNotifications();
  List<AlertListTile> alerts = [];

  print("number of notifs: " + controller.notifications.length.toString());
  controller.notifications.forEach((e) {
    print(e.desc);
    alerts.add(AlertListTile(notification: e));
  });
  return alerts;
}

List<Widget> refreshAlerts() {
  NotificationsController controller = Get.put(NotificationsController());
  controller.getNotifications();
  List<AlertListTile> alerts = [];

  print("number of notifs: " + controller.notifications.length.toString());
  controller.notifications.forEach((e) {
    print(e.desc);
    alerts.add(AlertListTile(notification: e));
  });
  return alerts;
}
