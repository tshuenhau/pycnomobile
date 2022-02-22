import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/Notification.dart';

class NotificationsController extends GetxController {
  AuthController authController = Get.find();
  RxList<Notification> notifications = RxList.empty();
  int alertCounter = 0;
  bool isSevere = false;

  Future<void> getNotifications() async {
    alertCounter = 0;
    isSevere = false;
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/notifications.json?TK=${authController.token}'));
    print(
        'https://stage.pycno.co.uk/api/v2/notifications.json?TK=${authController.token}');
    if (response.statusCode >= 200) {
      var body = jsonDecode(response.body);
      print(body);
      print(body.length);
      for (var i = 0; i < body.length; i++) {
        Notification notif = Notification.fromJson(body[i]);
        if (notif.severity > 0 && notif.state == 0) {
          notifications.add(notif);
          if (notif.severity > 3) {
            isSevere = true;
          }
          alertCounter++;
        }
      }
      print(notifications);
    } else {
      throw Exception("Unable to get notifications");
    }
  }
}
