import 'package:flutter/material.dart';
import 'package:pycnomobile/screens/BluetoothPage.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';
import 'package:pycnomobile/screens/AccountDetailsPage.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  AccountPage({Key? key}) : super(key: key);
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          authController.user.value == null
              ? CircularProgressIndicator()
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: authController.user.value!.profilePic != null
                      ? NetworkImage(
                          "https://pycno.co/${authController.user.value!.profilePic}")
                      : null,
                  child: authController.user.value!.profilePic == null
                      ? Icon(Icons.person, size: 50)
                      : null),
          SizedBox(height: 10),
          Text(authController.user.value!.username,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          TextButton.icon(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              icon: Icon(Icons.person),
              label: Text("Account Details"),
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (_) => AccountDetailsPage()),
                  )),
          TextButton.icon(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              icon: Icon(Icons.radar),
              label: Text("Scan for devices"),
              onPressed: () => Navigator.of(context, rootNavigator: true)
                  .push(MaterialPageRoute(builder: (_) => BluetoothPage()))),
          TextButton.icon(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              icon: Icon(Icons.logout),
              label: Text("Logout"),
              onPressed: () {
                authController.logout();
                Get.reset();
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (_) => false);
              }),
        ]));
  }
}
