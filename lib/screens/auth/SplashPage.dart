import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find();
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
                child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.width * 40 / 100,
                    maxWidth: MediaQuery.of(context).size.width * 40 / 100),
                child: Image(
                  image: NetworkImage(Theme.of(context).brightness ==
                          Brightness.light
                      ? auth.colorScheme['light']['companyLightLogo'].toString()
                      : auth.colorScheme['dark']['companyDarkLogo'].toString()),
                ),
              ))));
  }
}
