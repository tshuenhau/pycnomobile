import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/screens/SensorSearchPage.dart';
import 'package:pycnomobile/widgets/Search.dart';
import 'package:pycnomobile/widgets/SensorsListTile.dart';
import 'package:pycnomobile/controllers/ListOfSensorsController.dart';

class SensorListPage extends StatefulWidget {
  @override
  State<SensorListPage> createState() => _SensorListPageState();
}

class _SensorListPageState extends State<SensorListPage> {
  String query = ''; //! heres the query

  final ListOfSensorsController sensorsController =
      Get.put(ListOfSensorsController());

  var bottomNavigationBar;

  Future _refreshData() async {
    await sensorsController.getListOfSensors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: Column(
          children: [
            Search(
              text: "query",
              hintText: 'Search...',
              onChanged: (text) {
                setState(() {
                  this.query = text;
                });
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: Obx(
                  () => Center(
                    child: ListView.builder(
                      itemCount: sensorsController.listOfSensors.length + 1,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == sensorsController.listOfSensors.length) {
                          return Center(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              2.5 /
                                              100),
                                  child: Text(
                                    (DateTime.now().toString()),
                                  )));
                        }
                        Sensor sensor = sensorsController.listOfSensors[index];
                        return SensorsListTile(sensor: sensor);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
