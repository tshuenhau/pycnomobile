import 'package:flutter/material.dart';

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
      child: InkWell(
        onTap: () => {},
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
