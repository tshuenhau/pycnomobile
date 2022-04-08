import 'dart:async';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/widgets/Search.dart';
import 'package:pycnomobile/widgets/SensorsListTile.dart';
import 'package:pycnomobile/controllers/ListOfSensorsController.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:timeago/timeago.dart' as timeago;

class SensorListPage extends StatefulWidget {
  const SensorListPage({Key? key}) : super(key: key);

  @override
  State<SensorListPage> createState() => _SensorListPageState();
}

class _SensorListPageState extends State<SensorListPage>
    with WidgetsBindingObserver {
  late StreamSubscription<bool> keyboardSubscription;
  late AuthController authController = Get.find();
  late ListOfSensorsController sensorsController =
      Get.put(ListOfSensorsController());
  late Timer everyMinute;
  late DateTime now;

  @override
  void initState() {
    print("authController TOKEN " + authController.token);
    now = DateTime.now();
    everyMinute = Timer.periodic(Duration(seconds: 60), (Timer t) {
      setState(() {
        now = DateTime.now();
      });
    });
    sensorsController.context = context;
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

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
    WidgetsBinding.instance!.removeObserver(this);
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed &&
        ModalRoute.of(context)!.isCurrent &&
        authController.currentTab.value == 0) {
      EasyLoading.show(status: "Loading");
      await _refreshData();
      EasyLoading.dismiss();
    }
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
                          child: ListView.builder(
                            itemCount:
                                sensorsController.filteredListOfSensors.length +
                                    1,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              // print(sensorsController.lastRefreshTime.value);
                              // print(now);
                              // print(timeago.format(
                              //     sensorsController.lastRefreshTime.value));

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

                                          // now.toString()
                                          timeago.format(now == null
                                              ? DateTime.now()
                                              : sensorsController
                                                  .lastRefreshTime.value)

                                      // DateFormat.jms().format(
                                      //     sensorsController
                                      //         .lastRefreshTime.value)
                                      ),
                                ));
                              }
                              Sensor sensor = sensorsController
                                  .filteredListOfSensors[index];
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
          ),
        ));
  }
}
