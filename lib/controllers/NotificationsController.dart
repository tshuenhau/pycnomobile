import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/NotificationData.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/sensors/FixSensor.dart';
import 'dart:io';
import 'package:pycnomobile/screens/ErrorPage.dart';

class NotificationsController extends GetxController {
  AuthController authController = Get.find();
  RxList<NotificationData> unreadNotifications = RxList.empty();
  RxList<NotificationData> readNotifications = RxList.empty();
  Rx<int> alertCounter = 0.obs;
  Rx<bool> isSevere = false.obs;

  void onInit() {
    super.onInit();
    this.reload();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> reload() async {
    // refresh notifs every 1/2 hour

    Timer.periodic(new Duration(seconds: 1800), (timer) async {
      await this.getNotifications();
    });
  }

  void dismissNotification(NotificationData notif) async {
    // print(
    //     'https://stage.pycno.co/api/v2/data/notifications/${notif.id}?TK=${authController.token}');
    final response = await http.put(
        Uri.parse(
            'https://stage.pycno.co/api/v2/data/notifications/${notif.id}?TK=${authController.token}'),
        headers: {
          "content-type": "application/json",
        },
        body: json.encode({"state": 1}));

    if (response.statusCode == 200) {
      notif.markAsRead();
      unreadNotifications.removeWhere((x) => x.id == notif.id);
      readNotifications.add(notif);
      readNotifications.sort((a, b) => b.epoch.compareTo(a.epoch));
      // await getNotifications();
      alertCounter.value = unreadNotifications.length;
    } else {
      throw Exception("Could not mark as read. Try again!");
    }
  }

  Future<void> getNotifications() async {
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/notifications.json?TK=${authController.token}'));
    // print(
    //     'https://stage.pycno.co.uk/api/v2/notifications.json?TK=${authController.token}');
    if (response.statusCode == 200) {
      alertCounter.value = 0;
      isSevere.value = false;
      unreadNotifications.clear();
      readNotifications.clear();
      var body = jsonDecode(response.body);
      for (var i = 0; i < body.length; i++) {
        NotificationData notif = NotificationData.fromJson(body[i]);
        if (notif.severity > 0 && notif.state == 0) {
          unreadNotifications.add(notif);
          if (notif.severity > 3) {
            isSevere.value = true;
          }
          alertCounter.value++;
        } else if (notif.state == 1) {
          readNotifications.add(notif);
        }
      }
    } else {
      throw Exception("Unable to get notifications");
    }
  }

  Future<Sensor> getSensorFromNotifs(String uid) async {
    try {
      final response = await http.get(Uri.parse(
          'https://stage.pycno.co.uk/api/v2/data/no/$uid.json?TK=${authController.token}'));
      print(
          'https://stage.pycno.co.uk/api/v2/data/no/$uid.json?TK=${authController.token}');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        if (body["SLI"] != null) {
          //PULSE
          return FixSensor.fromJson(body);
        } else {
          return FixSensor.fromJson(body);
        }
        // TYPE_OF_SENSOR type = Sensor.getTypeOfSensor(body["UID"]);

        // if (type == TYPE_OF_SENSOR.MASTER_SOIL_SENSOR) {
        //   return MasterSoilSensor.fromJson(body);
        // } else if (type == TYPE_OF_SENSOR.NODE_SOIL_SENSOR) {
        //   return NodeSoilSensor.fromJson(body);
        // } else if (type == TYPE_OF_SENSOR.SONIC_ANEMOMETER) {
        //   return SonicAnemometer.fromJson(body);
        // } else {
        //   return RainGauge.fromJson(body);
        // }
      } else {
        throw Exception(
            "Failed to retrieve list of sensors"); //Ask UI to reload
      }
    } on SocketException catch (e) {
      Get.to(ErrorPage());
      throw Exception("No internet");
    }
  }
}
