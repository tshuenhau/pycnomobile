import 'package:flutter/material.dart';
import 'package:pycnomobile/screens/SensorSearchPage.dart';
import 'package:pycnomobile/widgets/SensorsListTile.dart';

class SensorListPage extends StatefulWidget {
  SensorListPage({Key? key}) : super(key: key);

  @override
  _SensorListPageState createState() => _SensorListPageState();
}

class _SensorListPageState extends State<SensorListPage> {
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
          child: Column(
        children: [
          SensorsListTile(
              sensorName: "Sensor Name",
              sensorSerial: "Sensor Model Number",
              availableGraphs: [""],
              imageUrl:
                  "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
        ],
      )),
      bottomNavigationBar:
          BottomNavigationBar(type: BottomNavigationBarType.fixed, items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.change_history),
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.change_history),
          label: 'Sensors',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.change_history),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.change_history),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.change_history),
          label: 'Account',
        ),
      ]),
    );
  }
}
