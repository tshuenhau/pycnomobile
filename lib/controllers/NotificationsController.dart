import 'package:get/get.dart';
import 'dart:convert';
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
