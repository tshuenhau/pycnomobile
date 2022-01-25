import 'package:flutter/material.dart';
import 'package:pycnomobile/screens/BluetoothPage.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Center(
              child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text("Scan for devices"),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => BluetoothPage())))),
        ]));
  }
}
