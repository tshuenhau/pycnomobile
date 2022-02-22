import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/NotificationData.dart';

class NotificationsController extends GetxController {
  AuthController authController = Get.find();
  RxList<NotificationData> notifications = RxList.empty();
  Rx<int> alertCounter = 0.obs;
  Rx<bool> isSevere = false.obs;

  Future<void> getNotifications() async {
    alertCounter.value = 0;
    isSevere.value = false;
    notifications.clear();
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/notifications.json?TK=${authController.token}'));
    print(
        'https://stage.pycno.co.uk/api/v2/notifications.json?TK=${authController.token}');
    if (response.statusCode >= 200) {
      var body = jsonDecode(response.body);
      for (var i = 0; i < body.length; i++) {
        NotificationData notif = NotificationData.fromJson(body[i]);
        if (notif.severity > 0 && notif.state == 0) {
          notifications.add(notif);
          if (notif.severity > 3) {
            isSevere.value = true;
          }
          alertCounter.value++;
        }
      }
      print(alertCounter);
      print(notifications);
    } else {
      throw Exception("Unable to get notifications");
    }
  }

  getSensorFromNotifs(String uid) {}
}
