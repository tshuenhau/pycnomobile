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
                        Text("Loading Dashboard...",
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
                  return child;
                }),
              ))));
  }
}
