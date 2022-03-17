import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/screens/AllGraphsPage.dart';
import 'package:pycnomobile/screens/SensorSummaryPage.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';

class SensorPage extends StatefulWidget {
  final Sensor sensor;
  SensorPage({Key? key, required this.sensor}) : super(key: key);

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  @override
  void initState() {
    super.initState();
    // initData();
  }

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color:
                Theme.of(context).colorScheme.primary, //change your color here
          ),
          title: Text(widget.sensor.name ?? ""),
          elevation: 0,
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.95),
          bottom: PreferredSize(
            preferredSize: new Size(
                double.infinity, MediaQuery.of(context).size.height * 5 / 100),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 1.5 / 100),
              height: MediaQuery.of(context).size.height * 5 / 100,
              child: TabBar(
                  labelPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 2 / 100),
                  labelColor: Theme.of(context).colorScheme.tertiary,
                  unselectedLabelColor: Theme.of(context).primaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Theme.of(context).colorScheme.surface),
                  tabs: [
                    Tab(
                      child: SizedBox(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Summary"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("All Graphs"),
                      ),
                    ),
                  ]),
            ),
          ),
          // actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.today))],
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5 / 100),
            child:
                TabBarView(physics: NeverScrollableScrollPhysics(), children: [
              SensorSummaryPage(sensor: widget.sensor),
              AllGraphsPage(
                sensor: widget.sensor,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
