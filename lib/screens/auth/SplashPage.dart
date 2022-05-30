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
                        child: Text("SENSOR CLUB",
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
                        height: MediaQuery.of(context).size.width * 10 / 100,
                        width: MediaQuery.of(context).size.width * 10 / 100,
                        child: CircularProgressIndicator(color: Colors.white)),
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
                bottom: MediaQuery.of(context).size.height * 20 / 100,
                child: Column(
                  children: [
                    (auth.colorScheme.isEmpty
                        ? Container()
                        : Container(
                            constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height *
                                    25 /
                                    100,
                                maxWidth: MediaQuery.of(context).size.width *
                                    50 /
                                    100),
                            child: Image.network(
                                auth.colorScheme['dark']['companyDarkLogo']
                                    .toString(),
                                loadingBuilder: (context, child, frame) {
                              if (frame == null) {
                                // fallback to placeholder
                                // return Padding(
                                //   padding: EdgeInsets.symmetric(
                                //       vertical: MediaQuery.of(context).size.height *
                                //           0.5 /
                                //           100),
                                //   child: CircularProgressIndicator(),
                                //);
                              }
                              return child;
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
