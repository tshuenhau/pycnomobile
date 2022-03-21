import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/App.dart';

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
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                onSubmitted: (s) async {
                  try {
                    EasyLoading.show(status: "Logging in...");
                    await authController.setDeviceData();
                    await authController.login(
                        username: usernameController.text,
                        password: passwordController.text);
                    EasyLoading.dismiss();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => App()));
                  } catch (e) {
                    EasyLoading.showError("invalid username/password");
                    print(e);
                  }
                },
                textInputAction: TextInputAction.go,
                controller: usernameController,
                decoration: new InputDecoration(
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    hintText: "username")),
            SizedBox(height: 5),
            TextField(
                obscureText: true,
                onSubmitted: (s) async {
                  try {
                    EasyLoading.show(status: "Logging in...");
                    await authController.setDeviceData();
                    await authController.login(
                        username: usernameController.text,
                        password: passwordController.text);
                    EasyLoading.dismiss();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => App()));
                  } catch (e) {
                    EasyLoading.showError("invalid username/password");
                  }
                },
                controller: passwordController,
                decoration: new InputDecoration(
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    hintText: "password")),
            SizedBox(height: 20),
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
                  EasyLoading.show(status: "Logging in...");
                  await authController.setDeviceData();
                  await authController.login(
                      username: usernameController.text,
                      password: passwordController.text);
                  EasyLoading.dismiss();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => App()));
                } catch (e) {
                  EasyLoading.showError("invalid username/password");
                  print(e);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
