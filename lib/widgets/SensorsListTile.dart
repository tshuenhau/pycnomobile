import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pycnomobile/controllers/SensorInfoController.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/screens/SensorPage.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/widgets/ActiveIndicator.dart';

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
      ),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: InkWell(
        onTap: () async {
          FocusScope.of(context).unfocus();
          SensorInfoController controller = Get.put(SensorInfoController());

          EasyLoading.show(status: "Loading...");
          try {
            await controller.getTimeSeriesForSparklines(sensor);
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => SensorPage(sensor: sensor)));
            EasyLoading.dismiss();
          } catch (e) {
            EasyLoading.showError('$e');
          }
        },
        child: ListTile(
            title: Text(
              sensor.name ?? "",
              overflow: TextOverflow.ellipsis,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100,
                            child: FittedBox(
                              child: Text(
                                  sensor.uid.startsWith("M")
                                      ? "M"
                                      : sensor.uid.startsWith("K")
                                          ? "N"
                                          : " ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.45),
                                  )),
                            ),
                          ),
                          SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 2 / 100),
                          Container(
                              height:
                                  MediaQuery.of(context).size.height * 2 / 100,
                              child: FittedBox(
                                child: Icon(
                                  Icons.sim_card,
                                  color: sensor.isSimActive
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.45)
                                      : Colors.red.withOpacity(0.75),
                                ),
                              )),
                        ],
                      ),
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
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height * 1 / 15,
                        height: MediaQuery.of(context).size.height * 1 / 15,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height * 1.5 / 100),
                            image: (sensor.img == null || sensor.img == "")
                                ? null
                                : DecorationImage(
                                    image: NetworkImage(
                                        "https://pycno.co/${sensor.img}"),
                                    fit: BoxFit.cover)),
                      ),
                      Positioned(
                        top: -MediaQuery.of(context).size.height * 0.75 / 100,
                        right: -MediaQuery.of(context).size.height * 0.75 / 100,
                        child: ActiveIndicator(sensor: sensor),
                      ),
                    ],
                  )
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
