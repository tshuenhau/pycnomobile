import 'package:flutter/material.dart';

class MultiSummaryCard extends StatelessWidget {
  final Map data;
  final String title;
  final String units;
  const MultiSummaryCard(
      {Key? key, required this.data, required this.title, required this.units})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: () => {},
          child: Container(
              width: MediaQuery.of(context).size.width * 1 / 2 - 20,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 2.5 / 100),
                child: Center(
                    child: Column(
                  children: [
                    Text(
                      title + " (" + units + ")",
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width * 3 / 100),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 1 / 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: buildDataPoints(data),
                      ),
                    ),
                  ],
                )),
              )),
        ));
  }

  List<Widget> buildDataPoints(Map data) {
    List<DataPoint> dataPoints = [];
    for (final mapEntry in data.entries) {
      final key = mapEntry.key.toString();
      final value = mapEntry.value?.toStringAsFixed(2) ?? "-";
      dataPoints.add(new DataPoint(label: key, value: value));
    }
    return dataPoints;
  }
}

class DataPoint extends StatelessWidget {
  final String label;
  final String value;

  const DataPoint({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 5 / 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 4 / 100),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            child: Text(
              "|",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 6 / 100),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 4 / 100),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
