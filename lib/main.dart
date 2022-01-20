import 'package:flutter/material.dart';
import 'package:pycnomobile/screens/SensorListPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SensorListPage(),
    );
  }
}
