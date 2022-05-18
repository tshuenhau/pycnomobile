import 'package:flutter/material.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:pycnomobile/theme/ThemeService.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find();
    print("is light mode " + auth.isLightMode.value.toString());
    return Obx(() => Container(
        color: ThemeService().colorScheme == {}
            ? Colors.black
            : auth.isLightMode.value
                ? HexColor(ThemeService()
                    .colorScheme['light']['companyLightBackground']
                    .toString())
                : HexColor(ThemeService()
                    .colorScheme['dark']['companyDarkBackground']
                    .toString()),
        child: ThemeService().colorScheme == {}
            ? null
            : Center(
                child: auth.isLightMode.value
                    ? Image.network(ThemeService()
                        .colorScheme['light']['companyLightLogo']
                        .toString())
                    : Image.network(ThemeService()
                        .colorScheme['dark']['companyDarkLogo']
                        .toString()))));
  }
}
