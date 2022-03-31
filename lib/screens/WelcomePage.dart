import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';
import 'package:pycnomobile/theme/GlobalTheme.dart';
import 'package:pycnomobile/theme/ThemeService.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/welcome_page.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        //color: globalTheme.colorScheme.background,
        child: Center(
            child: Padding(
          padding:
              EdgeInsets.all(MediaQuery.of(context).size.width * 8.5 / 100),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 1 / 100),
              Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"),
              SizedBox(height: MediaQuery.of(context).size.height * 40 / 100),
              ElevatedButton(
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                        Size.fromWidth(MediaQuery.of(context).size.width)),
                    alignment: Alignment.center,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                child: Text('Login'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              )
            ],
          ),
        )));
  }
}
