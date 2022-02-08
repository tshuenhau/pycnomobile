import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/controllers/ListOfSensorsController.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';

class SensorSearchPage extends StatelessWidget {
  SensorSearchPage({Key? key}) : super(key: key);
  final ListOfSensorsController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    /* Clear the search field */
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none),
            onChanged: (String searchTerms) {
              List<Sensor> sensors = controller.searchListOfSensors();
              print(sensors);
            },
          ),
        ),
      )),
      resizeToAvoidBottomInset: false,
    );
  }
}
