import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/screens/SensorPage.dart';
import 'package:get/get.dart';

class SensorsListTile extends StatelessWidget {
  final Sensor sensor;

  SensorsListTile({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        // side: BorderSide(
        //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.35),
        //     width: 1)
      ),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();

          Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => SensorPage(sensor: sensor, key: UniqueKey())));
        },
        child: ListTile(
            title: SizedBox(
              width: MediaQuery.of(context).size.width * 1 / 100,
              child: Text(
                sensor.name ?? "",
                overflow: TextOverflow.ellipsis,
              ),
            ),
            subtitle: Text(
              sensor.uid,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle,
                          color: sensor.isActive()
                              ? Colors.greenAccent.shade700
                              : Colors.redAccent.shade700,
                          size: MediaQuery.of(context).size.height * 2 / 100),
                      Padding(
                        padding: EdgeInsets.only(
                            top:
                                MediaQuery.of(context).size.height * 0.5 / 100),
                        child: Text(sensor.readableAgo ?? "",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    3 /
                                    100)),
                      )
                    ],
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width *
                          (1 / 20)), // give it width
                  Container(
                      width: MediaQuery.of(context).size.height * 1 / 15,
                      height: MediaQuery.of(context).size.height * 1 / 15,
                      child: Image(
                          image: NetworkImage(sensor.img == null
                              ? ""
                              : "https://pycno.co/${sensor.img}")))
                ])),
      ),
    );
  }
}

class AvailableGraphsIcons extends StatelessWidget {
  final List<String>
      availableGraphs; //! need to generate icons based on this. //! might need to change type
  const AvailableGraphsIcons({Key? key, required this.availableGraphs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.water),
      Icon(Icons.light),
      Icon(Icons.wb_sunny_outlined),
    ]);
  }
}
