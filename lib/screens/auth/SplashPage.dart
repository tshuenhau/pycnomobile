import 'package:flutter/material.dart';
import 'package:pycnomobile/theme/GlobalTheme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: globalTheme.colorScheme.background,
        child: Center(child: Image.asset("assets/images/pycno_logo.png")));
  }
}
