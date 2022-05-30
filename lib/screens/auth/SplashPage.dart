import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/App.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController controller;
  AuthController auth = Get.find();

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    checkFirstLogin();
    super.initState();
  }

  void checkFirstLogin() async {
    if (auth.isLoggedIn.value == AuthState.firstLogin) {
      await Future.delayed(Duration(seconds: 3));
      Get.to(App());
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: Image.network(
                    Theme.of(context).brightness == Brightness.light
                        ? auth.colorScheme['light']['companyLightLogo']
                            .toString()
                        : auth.colorScheme['dark']['companyDarkLogo']
                            .toString(),
                    frameBuilder: (context, child, frame, _) {
                  if (frame == null) {
                    // fallback to placeholder
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height *
                                  3.5 /
                                  100),
                          child: CircularProgressIndicator(),
                        ),
                        Text("Loading Profile...",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.65),
                                fontFamily: 'GothamRounded',
                                fontSize: MediaQuery.of(context).size.width *
                                    3.5 /
                                    100))
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      child,
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100),
                      LinearProgressIndicator(
                        value: controller.value,
                        semanticsLabel: 'Linear progress indicator',
                      ),
                    ],
                  );
                }),
              ))));
  }
}
