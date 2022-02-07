import 'package:flutter/material.dart';
import 'package:pycnomobile/screens/BluetoothPage.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  AccountPage({Key? key}) : super(key: key);
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
          CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(authController.user.value != null
                  ? authController.user.value!.profilePic == null
                      ? ""
                      : "https://pycno.co/${authController.user.value!.profilePic}"
                  : ""),
              child: authController.user.value != null
                  ? authController.user.value!.profilePic == null
                      ? Icon(Icons.person, size: 50)
                      : null
                  : null),
          Obx(() => Text(authController.user.value == null
              ? ""
              : authController.user.value!.username)),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: Text("Scan for devices"),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => BluetoothPage()))),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: Text("Logout"),
              onPressed: () {
                authController.logout();
                Get.reset();
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (_) => false);
              }),
        ])));
  }
}
