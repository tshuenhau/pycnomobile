import 'package:flutter/material.dart';
import 'package:pycnomobile/screens/SensorSearchPage.dart';

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

class SensorsListTile extends StatefulWidget {
  final String sensorName;
  final String sensorSerial;
  final List<String> availableGraphs; //! might need to change type
  final String imageUrl;

  SensorsListTile({
    Key? key,
    required this.sensorName,
    required this.sensorSerial,
    required this.availableGraphs,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<SensorsListTile> createState() => _SensorsListTileState();
}

class _SensorsListTileState extends State<SensorsListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: ListTile(
          title: Text(widget.sensorName),
          subtitle: Text(widget.sensorSerial),
          trailing: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                AvailableGraphsIcons(availableGraphs: widget.availableGraphs),
                SizedBox(
                    width: MediaQuery.of(context).size.width *
                        (1 / 20)), // give it width
                Image(image: NetworkImage(widget.imageUrl))
              ])),
    );
  }
}

class AvailableGraphsIcons extends StatelessWidget {
  final List<String>
      availableGraphs; //! need to generate icons based on this. //! might need to change type
  const AvailableGraphsIcons({Key? key, required this.availableGraphs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.water),
      Icon(Icons.light),
      Icon(Icons.wb_sunny_outlined),
    ]);
  }
}
