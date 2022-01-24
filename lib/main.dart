import 'package:flutter/material.dart';
import 'package:pycnomobile/App.dart';
import 'package:pycnomobile/screens/SensorListPage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  void dispose() {
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: App(),
    );
  }
}
