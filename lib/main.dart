import 'package:flutter/material.dart';
import 'package:pycnomobile/App.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';
import 'package:pycnomobile/screens/auth/SplashPage.dart';

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
    AuthController controller = Get.put(AuthController());
    return Obx(() => controller.isLoggedIn.value == AuthState.loggedIn
        ? MaterialApp(
            theme: ThemeData(
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: App())
        : controller.isLoggedIn.value == AuthState.loggedOut
            ? MaterialApp(
                theme: ThemeData(
                  // is not restarted.
                  primarySwatch: Colors.blue,
                ),
                home: LoginPage())
            : SplashPage());
  }
}
