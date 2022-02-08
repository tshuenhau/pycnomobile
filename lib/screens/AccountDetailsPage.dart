import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/controllers/AuthController.dart';

class AccountDetailsPage extends StatelessWidget {
  AccountDetailsPage({Key? key}) : super(key: key);
  final AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          BackButton(),
          Text("Username: ${authController.user.value!.username}"),
          Text("Email: ${authController.user.value!.username}"),
          Text("First Name: ${authController.user.value!.name}"),
          Text("Last Name: ${authController.user.value!.surname}"),
          Text("Phone Number: ${authController.user.value!.phoneNumber}"),
          Text("Locale: ${authController.user.value!.locale}"),
          Text("Farm Name: ${authController.user.value!.farmName}"),
          Text("Farm Type: ${authController.user.value!.farmType}"),
          Text("Farm Address: ${authController.user.value!.farmAddr}")
        ]));
  }
}
