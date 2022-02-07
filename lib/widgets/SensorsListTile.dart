import 'package:flutter/material.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/screens/SensorSummaryPage.dart';

class SensorsListTile extends StatelessWidget {
  final Sensor sensor;

  SensorsListTile({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Image URL: " + ""); //! URL

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: InkWell(
        onTap: () => {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SensorSummaryPage(sensor: sensor)))
        },
        child: ListTile(
            title: Text(
              sensor.name ?? "",
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              sensor.uid,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle,
                      color: sensor.isLive ?? false
                          ? Colors.greenAccent.shade400
                          : Colors.redAccent.shade400,
                      size: MediaQuery.of(context).size.height * 2 / 100),
                  SizedBox(
                      width: MediaQuery.of(context).size.width *
                          (1 / 20)), // give it width
                  Container(
                      width: MediaQuery.of(context).size.height * 1 / 15,
                      height: MediaQuery.of(context).size.height * 1 / 15,
                      child: Image(
                          image: NetworkImage(sensor.img == null
                              ? ""
                              : "https://pycno.co/${sensor.img}")))
                ])),
      ),
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
