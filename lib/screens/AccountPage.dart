import 'package:flutter/material.dart';
import 'package:pycnomobile/screens/BluetoothPage.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';
import 'package:pycnomobile/screens/AccountDetailsPage.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/theme/GlobalTheme.dart';
import 'package:pycnomobile/widgets/AccountListTile.dart';

class AccountPage extends StatelessWidget {
  AccountPage({Key? key, required this.resetFunction}) : super(key: key);
  Function resetFunction;
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Obx(() => Scaffold(
          backgroundColor: globalTheme.colorScheme.surface,
          body: Center(
            child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.5 / 100),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                        Column(
                          children: [
                            Text(authController.user.value!.username,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25)),
                            SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    2.5 /
                                    100),
                            authController.user.value == null
                                ? CircularProgressIndicator()
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage: authController
                                                .user.value!.profilePic !=
                                            null
                                        ? NetworkImage(
                                            "https://pycno.co/${authController.user.value!.profilePic}")
                                        : null,
                                    child:
                                        authController.user.value!.profilePic ==
                                                null
                                            ? Icon(Icons.person, size: 50)
                                            : null),
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 25 +
                                      MediaQuery.of(context).size.height *
                                          2.5 /
                                          100),
                              TextButton.icon(
                                  icon: Icon(Icons.radar),
                                  label: Text("Scan for devices"),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => BluetoothPage()))),
                              TextButton.icon(
                                  icon: Icon(Icons.logout),
                                  label: Text("Logout"),
                                  onPressed: () {
                                    authController.logout();
                                    Get.reset();
                                    Navigator.of(context, rootNavigator: true)
                                        .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (_) => LoginPage()),
                                            (_) => false);
                                  }),
                            ]),
                      ])),
                  // TextButton.icon(
                  //     icon: Icon(Icons.person),
                  //     label: Text("Account Details"),
                  //     onPressed: () => Navigator.of(context).push(
                  //           MaterialPageRoute(
                  //               builder: (_) => AccountDetailsPage()),
                  //         )),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.5 / 100),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            color: globalTheme.colorScheme.background,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(30))),
                        child: Column(children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 2 / 100),
                          AccountListTile(
                              title: "Username",
                              value: "${authController.user.value!.username}",
                              authController: authController),
                          AccountListTile(
                              title: "Email",
                              value:
                                  "${authController.user.value!.username}@pycno.co",
                              authController: authController),
                          AccountListTile(
                              title: "First Name",
                              value: "${authController.user.value!.name}",
                              authController: authController),
                          AccountListTile(
                              title: "Last Name",
                              value: "${authController.user.value!.surname}",
                              authController: authController),
                          AccountListTile(
                              title: "Phone Number",
                              value:
                                  "${authController.user.value!.phoneNumber}",
                              authController: authController),
                          AccountListTile(
                              title: "Locale",
                              value: "${authController.user.value!.locale}",
                              authController: authController),
                          AccountListTile(
                              title: "Farm Name",
                              value: "${authController.user.value!.farmName}",
                              authController: authController),
                          AccountListTile(
                              title: "Farm Type",
                              value: "${authController.user.value!.farmType}",
                              authController: authController),
                          AccountListTile(
                              title: "Farm Address",
                              value: "${authController.user.value!.farmAddr}",
                              authController: authController),
                          SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  2.5 /
                                  100),
                        ])),
                  )
                ]),
          ),
        ));
  }
}
