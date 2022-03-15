import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/NotificationData.dart';
import 'package:pycnomobile/screens/SensorPage.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart';
import 'package:pycnomobile/controllers/NotificationsController.dart';

class AlertListTile extends StatelessWidget {
  AlertListTile({Key? key, required this.notification}) : super(key: key);

  final NotificationData notification;
  final NotificationsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    print(notification.desc);
    print("notification time UTC: " +
        DateTime.fromMillisecondsSinceEpoch(notification.epoch, isUtc: true)
            .toUtc()
            .toString());
    print("notification time Local: " +
        DateTime.fromMillisecondsSinceEpoch(notification.epoch, isUtc: true)
            .toLocal()
            .toString());
    print(DateTime.fromMillisecondsSinceEpoch(notification.epoch, isUtc: true)
        .timeZoneOffset);
    print(DateTime.now());
    return Dismissible(
      key: Key(this.notification.id.toString()),
      onDismissed: (notificationId) {
        //delete the notification
        controller.dismissNotification(this.notification);
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 10 / 100,
            child: Center(
              child: InkWell(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  EasyLoading.show(status: "Loading");
                  Sensor sensor = await controller
                      .getSensorFromNotifs(this.notification.uid);
                  EasyLoading.dismiss();
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) =>
                          SensorPage(sensor: sensor, key: UniqueKey())));
                  controller.dismissNotification(this.notification);
                },
                child: ListTile(
                    leading: Container(
                      height: double.infinity,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 2 / 100),
                          child: Icon(notification.key == "event_frost"
                              ? Icons.ac_unit
                              : notification.key == "event_low_battery"
                                  ? Icons.battery_alert
                                  : Icons.warning)),
                    ),
                    //title: Text(sensor.name ?? sensor.uid),
                    title: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 1 / 100),
                      child: Text(notification.descText ?? ""),
                    ),
                    subtitle: Text(notification.uid),
                    trailing: SizedBox(
                      width: MediaQuery.of(context).size.width * 20 / 100,
                      child: AutoSizeText(
                          // "about an hour ago"
                          timeago.format(DateTime.fromMillisecondsSinceEpoch(
                            notification.epoch,
                          )),
                          maxLines: 2,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 3 / 100)),
                    )),
              ),
            ),
          )),
    );
  }
}
