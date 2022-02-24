import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/model/NotificationData.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/sensors/MasterSoilSensor.dart';
import 'package:pycnomobile/model/sensors/SonicAnemometer.dart';
import 'package:pycnomobile/model/sensors/NodeSoilSensor.dart';
import 'package:pycnomobile/model/sensors/RainGauge.dart';

class NotificationsController extends GetxController {
  AuthController authController = Get.find();
  RxList<NotificationData> unreadNotifications = RxList.empty();
  RxList<NotificationData> readNotifications = RxList.empty();
  Rx<int> alertCounter = 0.obs;
  Rx<bool> isSevere = false.obs;

  void onInit() async {
    super.onInit();
    // await this.reload();
  }

  Future<void> reload() async {
    Timer.periodic(new Duration(seconds: 10), (timer) async {
      print("refresh notifs");
      await this.getNotifications();
    });
  }

  void dismissNotification(NotificationData notif) {
    notif.markAsRead();
    unreadNotifications.removeWhere((x) => x.id == notif.id);
    readNotifications.add(notif);
    readNotifications.sort((a, b) => b.epoch.compareTo(a.epoch));
  }

  Future<void> getNotifications() async {
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/notifications.json?TK=${authController.token}'));
    // print(
    //     'https://stage.pycno.co.uk/api/v2/notifications.json?TK=${authController.token}');
    if (response.statusCode >= 200) {
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
    final response = await http.get(Uri.parse(
        'https://stage.pycno.co.uk/api/v2/data/no/$uid.json?TK=${authController.token}'));
    print(
        'https://stage.pycno.co.uk/api/v2/data/no/$uid.json?TK=${authController.token}');
    if (response.statusCode >= 200) {
      var body = jsonDecode(response.body);
      TYPE_OF_SENSOR type = Sensor.getTypeOfSensor(body["UID"]);

      if (type == TYPE_OF_SENSOR.MASTER_SOIL_SENSOR) {
        return MasterSoilSensor.fromJson(body);
      } else if (type == TYPE_OF_SENSOR.NODE_SOIL_SENSOR) {
        return NodeSoilSensor.fromJson(body);
      } else if (type == TYPE_OF_SENSOR.SONIC_ANEMOMETER) {
        return SonicAnemometer.fromJson(body);
      } else {
        return RainGauge.fromJson(body);
      }
    } else {
      throw Exception("Failed to retrieve list of sensors"); //Ask UI to reload
    }
  }
}
