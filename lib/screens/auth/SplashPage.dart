import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pycnomobile/theme/ThemeService.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ThemeService().colorScheme["companyColors1"] == null
            ? Colors.black
            : HexColor(ThemeService()
                .colorScheme["companyColors1"]['dark']['background']
                .toString()),
        child: ThemeService().colorScheme["companyColors1"] == null
            ? null
            : Center(child: Image.asset("assets/images/pycno_logo.png")));
  }
}
