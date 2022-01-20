import 'dart:ffi';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:pycnomobile/model/Sensor.dart';
import 'package:pycnomobile/screens/SensorSearchPage.dart';
import 'package:pycnomobile/widgets/CustomBottomNavigationBar.dart';
import 'package:pycnomobile/widgets/SensorsListTile.dart';
import 'package:pycnomobile/controllers/ListOfSensorsController.dart';

class SensorListPage extends StatelessWidget {
//   SensorListPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _SensorListPageState createState() => _SensorListPageState();
// }

// class _SensorListPageState extends State<SensorListPage> {
  final ListOfSensorsController sensorsController =
      Get.put(ListOfSensorsController());
  Future _refreshData() async {
    await sensorsController.getListOfSensors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => SensorSearchPage())),
            icon: Icon(Icons.search)),
        title: Text("Sensor List"),
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.filter_list)),
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: Obx(
            () => ListView.builder(
              itemCount: sensorsController.listOfSensors.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Sensor sensor = sensorsController.listOfSensors[index];
                return SensorsListTile(
                    availableGraphs: [""],
                    sensorName: sensor.name ?? "",
                    imageUrl: sensor.img ?? "",
                    sensorSerial: sensor.uid);
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 1),
    );
  }
}
