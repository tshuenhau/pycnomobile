import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/widgets/Search.dart';
import 'package:pycnomobile/widgets/SensorsListTile.dart';
import 'package:pycnomobile/controllers/ListOfSensorsController.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:io';

class SensorListPage extends StatefulWidget {
  const SensorListPage({Key? key}) : super(key: key);

  @override
  State<SensorListPage> createState() => _SensorListPageState();
}

class _SensorListPageState extends State<SensorListPage> {
  late StreamSubscription<bool> keyboardSubscription;
  AuthController authController = Get.find();
  ListOfSensorsController sensorsController =
      Get.put(ListOfSensorsController());

  late Timer everyMinute;
  late DateTime now;

  bool displayInactive = false;

  @override
  void initState() {
    now = DateTime.now();
    everyMinute = Timer.periodic(Duration(seconds: 60), (Timer t) {
      if (this.mounted) {
        setState(() {
          now = DateTime.now();
        });
      }
    });
    sensorsController.context = context;

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
  didChangeDependencies() {
    context.dependOnInheritedWidgetOfExactType();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    Get.delete<ListOfSensorsController>();
    super.dispose();
  }

  Future _refreshData() async {
    await sensorsController.getListOfSensors();

    sensorsController.searchListOfSensors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 3 / 100),
          child: Center(
            child: Column(
              children: [
                Search(
                  hintText: "Search...",
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    child: Obx(
                      () => Center(
                        child: Scrollbar(
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
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              2.5 /
                                              100),
                                  child: Text("Last refreshed " +
                                      timeago.format(sensorsController
                                          .lastRefreshTime.value)),
                                ));
                              }
                              Sensor sensor = sensorsController
                                  .filteredListOfSensors[index];

                              if (sensor.isActive() == IS_ACTIVE.INACTIVE &&
                                  !displayInactive) {
                                return Container();
                              }
                              return SensorsListTile(sensor: sensor);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await EasyLoading.showInfo(
              (!displayInactive ? "Showing" : "Hiding") +
                  " ${sensorsController.inactiveListOfSensors.length} Inactive Sensor" +
                  (sensorsController.inactiveListOfSensors.length > 0
                      ? "s"
                      : ""),
              dismissOnTap: true);
          if (this.mounted) {
            setState(() {
              // Your state change code goes here
              displayInactive = !displayInactive;
            });
          }
        },
        tooltip: displayInactive ? "Hide Inactive" : "Display Inactive",
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
            displayInactive == false ? Icons.visibility_off : Icons.visibility),
      ),
    );
  }
}
