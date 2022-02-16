import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/SummaryCardBuilder.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/screens/AllGraphsPage.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:pycnomobile/screens/SensorSummaryPage.dart';
import 'package:pycnomobile/theme/GlobalTheme.dart';

class SensorPage extends StatefulWidget {
  final Sensor sensor;
  SensorPage({Key? key, required this.sensor}) : super(key: key);

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  final _pageController = PageController();

  final _currentPageNotifier = ValueNotifier<int>(0);

  List<Widget> _screens = [];

  void initData() {
    _screens.add(SensorSummaryPage(sensor: widget.sensor));
    _screens.add(AllGraphsPage(sensor: widget.sensor));
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.sensor.name ?? ""),
        elevation: 0,
        backgroundColor: globalTheme.colorScheme.background.withOpacity(0.95),
        // actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.today))],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 9.5 / 10,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // SizedBox(height: MediaQuery.of(context).size.height * 12.5 / 100),
              _buildCircleIndicator(),
              _buildPageView(),
            ],
          ),
        ),
      ),
    );
  }

  _buildPageView() {
    print(_currentPageNotifier.value);
    return Expanded(
        child: PageView.builder(
            physics: _currentPageNotifier.value == 1
                ? NeverScrollableScrollPhysics()
                : AlwaysScrollableScrollPhysics(),
            itemCount: _screens.length,
            controller: _pageController,
            itemBuilder: (BuildContext context, int index) {
              return _screens[index];
            },
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            }));
  }

  _buildCircleIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CirclePageIndicator(
        itemCount: _screens.length,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
