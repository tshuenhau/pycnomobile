import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/controllers/AuthController.dart';

class AccountDetailsPage extends StatelessWidget {
  AccountDetailsPage({Key? key}) : super(key: key);
  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Text("Username: "),
      Text("Email: "),
      Text("First Name: "),
      Text("Last Name:"),
      Text("Phone Number:"),
      Text("Locale:"),
      Text("Farm Name:"),
      Text("Farm Type:"),
      Text("Farm Address:")
    ]));
  }
}
