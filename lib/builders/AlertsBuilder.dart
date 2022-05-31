// import 'package:flutter/material.dart';
// import 'package:Sensr/model/NotificationData.dart';
// import 'package:Sensr/widgets/AlertListTile.dart';
// import 'package:Sensr/controllers/NotificationsController.dart';
// import 'package:get/get.dart';

// List<Widget> buildAlerts({required bool isRead}) {
//   NotificationsController controller = Get.put(NotificationsController());
//   // controller.getNotifications();
//   List<AlertListTile> alerts = [];

//   if (isRead) {
//     controller.readNotifications.forEach((e) {
//       print(e.desc);
//       alerts.add(AlertListTile(notification: e));
//     });
//   } else {
//     controller.unreadNotifications.forEach((e) {
//       print(e.desc);
//       alerts.add(AlertListTile(notification: e));
//     });
//   }
//   return alerts;
// }

// List<Widget> refreshAlerts({required bool isRead}) {
//   NotificationsController controller = Get.put(NotificationsController());
//   controller.getNotifications();
//   List<AlertListTile> alerts = [];

//   if (isRead) {
//     controller.readNotifications.forEach((e) {
//       print(e.desc);
//       alerts.add(AlertListTile(notification: e));
//     });
//   } else {
//     controller.unreadNotifications.forEach((e) {
//       print(e.desc);
//       alerts.add(AlertListTile(notification: e));
//     });
//   }

//   return alerts;
// }
