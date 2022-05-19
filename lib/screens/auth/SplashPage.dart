import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pycnomobile/theme/ThemeService.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find();
    print("colorScheme: " + auth.colorScheme.toString());
    return Obx(() => Container(
        color: auth.colorScheme.isEmpty
            ? Colors.black
            : Theme.of(context).brightness == Brightness.light
                ? HexColor(auth.colorScheme['light']['companyLightBackground']
                    .toString())
                : HexColor(auth.colorScheme['dark']['companyDarkBackground']
                    .toString()),
        child: auth.colorScheme.isEmpty
            ? null
            : Center(
                child: Theme.of(context).brightness == Brightness.light
                    ? Image.network(auth.colorScheme['light']
                            ['companyLightLogo']
                        .toString())
                    : Image.network(auth.colorScheme['dark']['companyDarkLogo']
                        .toString()))));
  }
}
