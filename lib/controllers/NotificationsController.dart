import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/Notification.dart';

class NotificationsController extends GetxController {
  AuthController authController = Get.find();
  RxList<Notification> notifications = RxList.empty();

  Future<void> getNotifications() async {
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/notifications.json?TK=${authController.token}'));

    if (response.statusCode >= 200) {
      var body = jsonDecode(response.body);
      for (var i = 0; i < body.length; i++) {
        notifications.add(Notification.fromJson(body));
      }
    } else {
      throw Exception("Unable to get notifications");
    }
  }
}
