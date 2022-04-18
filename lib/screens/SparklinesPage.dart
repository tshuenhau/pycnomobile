import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/builders/SparklinesBuilder.dart';
import 'package:pycnomobile/controllers/SensorInfoController.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/widgets/SparklineListTile.dart';

class SparklinesPage extends StatelessWidget {
  SparklinesPage({Key? key, required this.sensor}) : super(key: key);
  Sensor sensor;
  SensorInfoController controller = Get.put(SensorInfoController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initSparklines(sensor: sensor, context: context),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          EasyLoading.show(status: "Loading");
          return Container();
        } else {
          EasyLoading.dismiss();
          return Container(
              child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.sparkLines.length,
            itemBuilder: (BuildContext context, int index) {
              return Text('5');
            },
          ));
        }
      }),
    );
  }
}
