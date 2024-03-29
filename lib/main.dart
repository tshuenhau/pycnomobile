import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Sensr/App.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Sensr/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:Sensr/screens/WelcomePage.dart';
import 'package:Sensr/screens/auth/LoginPage.dart';
import 'package:Sensr/screens/auth/SplashPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/services.dart';
import 'package:Sensr/theme/GlobalTheme.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Sensr/theme/ThemeService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  await GetStorage.init(); // add this

  runApp(MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.black
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.black
    ..textColor = Colors.black
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false
    ..boxShadow = <BoxShadow>[]
    ..maskType = EasyLoadingMaskType.custom;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  void dispose() {
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    configLoading();
    AuthController controller = Get.put(AuthController());
    return Obx(() {
      print('hi im auth ' + controller.isLoggedIn.value.toString());
      return GetMaterialApp(
        theme: controller.colorScheme.isEmpty
            ? globalTheme
            : getTheme(ThemeService().colorScheme, true),
        darkTheme: ThemeService().colorScheme.isEmpty
            ? globalTheme
            : getTheme(ThemeService().colorScheme, false),
        themeMode: ThemeService().theme,
        home: controller.isLoggedIn.value == AuthState.loggedIn
            ? App()
            : controller.isLoggedIn.value == AuthState.loggedOut
                ? WelcomePage()
                : SplashPage(),
        builder: EasyLoading.init(),
      );
    });
  }
}
