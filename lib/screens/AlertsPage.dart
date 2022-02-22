import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/AlertsBuilder.dart';
import 'package:pycnomobile/theme/GlobalTheme.dart';
import 'package:pycnomobile/widgets/AlertListTile.dart';
import 'package:get/get.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({Key? key}) : super(key: key);

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Alerts"),
          elevation: 0,
          backgroundColor: globalTheme.colorScheme.background.withOpacity(0.95),
          // actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.today))],
        ),
        body: Center(
            child: ListView(
          children: buildAlerts(),
        )));
  }
}
