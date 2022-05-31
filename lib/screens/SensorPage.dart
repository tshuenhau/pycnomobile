import 'package:flutter/material.dart';
import 'package:Sensr/model/sensors/Sensor.dart';
import 'package:Sensr/screens/AllGraphsPage.dart';
import 'package:Sensr/screens/SparklinesPage.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

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
                  indicator: DotIndicator(
                    color: Theme.of(context).colorScheme.tertiary,
                    distanceFromCenter: -16,
                    radius: 3,
                    paintingStyle: PaintingStyle.fill,
                  ),
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
          child: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
            SparklinesPage(sensor: widget.sensor, key: UniqueKey()),
            AllGraphsPage(
              key: widget.key,
              sensor: widget.sensor,
            )
          ]),
        ),
      ),
    );
  }
}
