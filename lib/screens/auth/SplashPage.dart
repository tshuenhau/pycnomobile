import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:Sensr/controllers/AuthController.dart';
import 'package:Sensr/App.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'dart:math';

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
    // EasyLoading.instance
    //   ..maskType = EasyLoadingMaskType.custom
    //   ..backgroundColor = Colors.transparent
    //   ..maskColor = Colors.transparent
    //   ..loadingStyle = EasyLoadingStyle.custom
    //   ..indicatorColor = Colors.white
    //   ..textStyle = TextStyle(
    //       color: Colors.white,
    //       fontSize: 15,
    //       fontWeight: FontWeight.bold,
    //       fontFamily: 'nulshock',
    //       shadows: [
    //         Shadow(
    //             color: Colors.black.withOpacity(0.65),
    //             offset: const Offset(8, 3),
    //             blurRadius: 30),
    //       ]);
    // EasyLoading.show(
    //   status: 'Loading Dashboard...',
    //   maskType: EasyLoadingMaskType.custom,
    // );
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
    // EasyLoading.dismiss();
    // EasyLoading.instance..textStyle = null;
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/vineyard.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 8 / 100),
          child: Stack(
            alignment: Alignment.center,

            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 15 / 100,
                child: Column(
                  children: [
                    Image(
                        width: MediaQuery.of(context).size.width * 15 / 100,
                        height: MediaQuery.of(context).size.width * 15 / 100,
                        image: AssetImage("assets/images/app_logo.png")),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 40 / 100,
                      child: Center(
                        child: Text("Sensr",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width *
                                    5.5 /
                                    100,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'nulshock',
                                shadows: [
                                  Shadow(
                                      color: Colors.black.withOpacity(0.9),
                                      offset: const Offset(10, 5),
                                      blurRadius: 30),
                                ])),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2.5,
                //bottom: MediaQuery.of(context).size.height / 3,
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.width * 15 / 100,
                        width: MediaQuery.of(context).size.width * 15 / 100,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: LoadingIndicator(
                              indicatorType: Indicator.ballSpinFadeLoader,
                              colors: [
                                Colors.white,
                              ],
                              pathBackgroundColor: Colors.white),
                        )),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 5 / 100),
                    Text("Loading Dashboard...",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.width * 3.5 / 100,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'nulshock',
                            shadows: [
                              Shadow(
                                  color: Colors.black.withOpacity(0.65),
                                  offset: const Offset(8, 3),
                                  blurRadius: 30),
                            ]))
                  ],
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 15 / 100,
                child: Column(
                  children: [
                    (auth.colorScheme.isEmpty
                        ? Container()
                        : Container(
                            constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height *
                                    15 /
                                    100,
                                maxWidth: MediaQuery.of(context).size.width *
                                    50 /
                                    100),
                            child: Image.network(
                                auth.colorScheme['dark']['companyDarkLogo']
                                    .toString(),
                                frameBuilder: (context, child, frame, _) {
                              if (frame == null) {
                                // fallback to placeholder

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.5 /
                                              100),
                                  child: Column(
                                    children: [],
                                  ),
                                );
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("POWERED BY",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              2.5 /
                                              100,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'nulshock',
                                          shadows: [
                                            Shadow(
                                                color: Colors.black
                                                    .withOpacity(0.65),
                                                offset: const Offset(6, 2),
                                                blurRadius: 30),
                                          ])),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              2 /
                                              100),
                                  child,
                                ],
                              );
                            }),
                          )),
                  ],
                ),
              ),
            ],
          ),
        ))));
  }
}
