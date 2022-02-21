import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late StreamSubscription<bool> keyboardSubscription;

  Future _refreshData() async {
    await sensorsController.getListOfSensors();
    sensorsController.searchListOfSensors();
  }

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible == false) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ListOfSensorsController sensorsController =
        Get.put(ListOfSensorsController());

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "My Sensors",
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: Column(
              children: [
                Search(
                  hintText: 'Search...',
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    child: Obx(
                      () => Center(
                        child: ListView.builder(
                          itemCount:
                              sensorsController.filteredListOfSensors.length +
                                  1,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index ==
                                sensorsController
                                    .filteredListOfSensors.length) {
                              return Center(
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              2.5 /
                                              100),
                                      child: Text(
                                        (DateFormat.jms()
                                            .format(DateTime.now())),
                                      )));
                            }
                            Sensor sensor =
                                sensorsController.filteredListOfSensors[index];
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
        ));
  }
}
