import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/NotificationData.dart';
import 'package:pycnomobile/screens/SensorPage.dart';
import 'package:timeago/timeago.dart' as timeago;

class AlertListTile extends StatelessWidget {
  const AlertListTile({Key? key, required this.notification}) : super(key: key);

  final NotificationData notification;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(this.notification.id.toString()),
      onDismissed: (notificationId) {
        //delete the notification
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
                onTap: () {
                  FocusScope.of(context).unfocus();
                  // Navigator.of(context).push(CupertinoPageRoute(
                  //     builder: (_) => SensorPage(sensor: sensor)));
                },
                child: ListTile(
                    leading: Container(
                      height: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 2 / 100),
                        child: Icon(Icons.ac_unit),
                      ),
                    ),
                    //title: Text(sensor.name ?? sensor.uid),
                    title: Text(notification.uid),
                    subtitle: Text(notification.desc ?? ""),
                    trailing: Text(
                        timeago.format(DateTime.fromMillisecondsSinceEpoch(
                            notification.epoch)),
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 3 / 100))),
              ),
            ),
          )),
    );
  }
}
