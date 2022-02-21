import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/screens/SensorPage.dart';

class AlertListTile extends StatelessWidget {
  const AlertListTile(
      {Key? key,
      required this.icon,
      required this.sensor,
      required this.notificationId,
      required this.description,
      required this.timeAgo})
      : super(key: key);

  final Icon icon;
  final Sensor sensor;
  final String notificationId;
  final String description;
  final String timeAgo;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(this.notificationId),
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
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) => SensorPage(sensor: sensor)));
                },
                child: ListTile(
                    leading: Container(
                      height: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 2 / 100),
                        child: icon,
                      ),
                    ),
                    //title: Text(sensor.name ?? sensor.uid),
                    title: Text(sensor.uid),
                    subtitle: Text(description),
                    trailing: Text(timeAgo,
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 3 / 100))),
              ),
            ),
          )),
    );
  }
}