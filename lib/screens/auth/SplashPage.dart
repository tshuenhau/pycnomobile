import 'package:flutter/material.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find();
    return Obx(() => Container(
        color: controller.theme["companyColors1"] == null
            ? Colors.black
            : HexColor(controller.theme["companyColors1"]['dark']['background']
                .toString()),
        child: controller.theme["companyColors1"] == null
            ? null
            : Center(child: Image.asset("assets/images/pycno_logo.png"))));
  }
}
