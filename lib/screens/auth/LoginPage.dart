import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Sensr/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:Sensr/App.dart';
import 'package:Sensr/screens/auth/SplashPage.dart';
import 'package:Sensr/controllers/ListOfSensorsController.dart';
import 'dart:io';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController =
        new TextEditingController();
    final TextEditingController passwordController =
        new TextEditingController();

    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/vineyard.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.all(MediaQuery.of(context).size.width * 8.5 / 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 15 / 100),
              Image(
                  width: MediaQuery.of(context).size.width * 15 / 100,
                  height: MediaQuery.of(context).size.width * 15 / 100,
                  image: AssetImage("assets/images/app_logo.png")),
              SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
              SizedBox(
                width: MediaQuery.of(context).size.width * 40 / 100,
                child: Text(
                  "Sensr",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 5.5 / 100,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'nulshock',
                      shadows: [
                        Shadow(
                            color: Colors.black.withOpacity(0.9),
                            offset: const Offset(10, 5),
                            blurRadius: 30),
                      ]),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 5 / 100),
              TextField(
                  textInputAction: TextInputAction.go,
                  controller: usernameController,
                  onSubmitted: (string) async {
                    try {
                      await authController.setDeviceData();
                      await authController.login(
                          username: usernameController.text,
                          password: passwordController.text);
                      // EasyLoading.dismiss();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SplashPage()));
                    } on SocketException catch (e) {
                      EasyLoading.showError(
                          "Check your connection and try again!");
                    } catch (e) {
                      EasyLoading.showError("invalid username/password");
                      print(e);
                    }
                  },
                  decoration: new InputDecoration(
                      fillColor: Theme.of(context).colorScheme.surface,
                      filled: true,
                      hintText: "username")),
              SizedBox(height: MediaQuery.of(context).size.height * 1 / 100),
              TextField(
                  obscureText: true,
                  onSubmitted: (string) async {
                    try {
                      await authController.setDeviceData();
                      await authController.login(
                          username: usernameController.text,
                          password: passwordController.text);
                      // EasyLoading.dismiss();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SplashPage()));
                    } on SocketException catch (e) {
                      EasyLoading.showError(
                          "Check your connection and try again!");
                    } catch (e) {
                      EasyLoading.showError("invalid username/password");
                      print(e);
                    }
                  },
                  controller: passwordController,
                  decoration: new InputDecoration(
                      fillColor: Theme.of(context).colorScheme.surface,
                      filled: true,
                      hintText: "password")),
              SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
              ElevatedButton(
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                        Size.fromWidth(MediaQuery.of(context).size.width)),
                    alignment: Alignment.center,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                child: Text('Login'),
                onPressed: () async {
                  try {
                    await authController.setDeviceData();
                    await authController.login(
                        username: usernameController.text,
                        password: passwordController.text);
                    // EasyLoading.dismiss();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SplashPage()));
                  } on SocketException catch (e) {
                    EasyLoading.showError(
                        "Check your connection and try again!");
                  } catch (e) {
                    EasyLoading.showError("invalid username/password");
                    print(e);
                  }
                },
              ),
              // SizedBox(height: MediaQuery.of(context).size.height * 3.5 / 100),
              // Text(
              //     "You should've received your login details with our hardware devices.",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //         color: Colors.white.withOpacity(0.85),
              //         fontFamily: 'GothamRounded',
              //         fontSize: MediaQuery.of(context).size.width * 3 / 100)),
            ],
          ),
        ),
      ),
    );
  }
}
