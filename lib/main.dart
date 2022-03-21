import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pycnomobile/App.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';
import 'package:pycnomobile/screens/auth/SplashPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/services.dart';
import 'package:pycnomobile/theme/GlobalTheme.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pycnomobile/model/ThemeService.dart';

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
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
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

    return Obx(
      () => GetMaterialApp(
        theme: ThemeService().colorScheme.isEmpty
            ? globalTheme
            : getTheme(ThemeService().colorScheme, true),
        darkTheme: ThemeService().colorScheme.isEmpty
            ? globalTheme
            : getTheme(ThemeService().colorScheme, false),
        themeMode: ThemeService().theme,
        home: controller.isLoggedIn.value == AuthState.loggedIn
            ? App()
            : controller.isLoggedIn.value == AuthState.loggedOut
                ? LoginPage()
                : SplashPage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
