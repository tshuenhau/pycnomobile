import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:pycnomobile/model/Sensor.dart';
import 'package:pycnomobile/screens/SensorSearchPage.dart';
import 'package:pycnomobile/widgets/SensorsListTile.dart';
import 'package:pycnomobile/controllers/ListOfSensorsController.dart';

class SensorListPage extends StatelessWidget {
  final ListOfSensorsController sensorsController =
      Get.put(ListOfSensorsController());

  var bottomNavigationBar;
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
                return SensorsListTile(sensor: sensor);
              },
            ),
          ),
        ),
      ),
    );
  }
}
