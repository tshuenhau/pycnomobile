import 'package:flutter/material.dart';
import 'package:Sensr/screens/BluetoothPage.dart';
import 'package:Sensr/screens/auth/LoginPage.dart';
import 'package:Sensr/screens/AccountDetailsPage.dart';
import 'package:Sensr/controllers/AuthController.dart';
import 'package:Sensr/controllers/ListOfSensorsController.dart';
import 'package:Sensr/controllers/NotificationsController.dart';
import 'package:Sensr/controllers/TimeSeriesController.dart';
import 'package:get/get.dart';
import 'package:Sensr/widgets/AccountListTile.dart';
import 'package:Sensr/theme/ThemeService.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key? key, required this.resetFunction}) : super(key: key);
  Function resetFunction;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late int? themeIndex;

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Obx(() => Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SingleChildScrollView(
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 3.5 / 100),
                  Container(
                      child: IntrinsicHeight(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              authController.user.value == null
                                  ? CircularProgressIndicator()
                                  : CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.2),
                                      radius: 50,
                                      backgroundImage: authController
                                                  .user.value!.profilePic !=
                                              null
                                          ? NetworkImage(
                                              "https://pycno.co/${authController.user.value!.profilePic}",
                                            )
                                          : null,
                                      child: authController
                                                  .user.value!.profilePic ==
                                              null
                                          ? Icon(Icons.person, size: 50)
                                          : null),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      2 /
                                      100),
                              Text(authController.user.value!.username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
                            ],
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // TextButton.icon(
                                //     icon: Icon(Icons.radar),
                                //     label: Text("Scan for devices"),
                                //     onPressed: () => Navigator.of(context).push(
                                //         MaterialPageRoute(
                                //             builder: (_) => BluetoothPage()))),
                                TextButton.icon(
                                    icon: Icon(Icons.palette_outlined),
                                    label: Text("Change Theme"),
                                    onPressed: () {
                                      if (Theme.of(context).brightness ==
                                          Brightness.light) {
                                        themeIndex = 0;
                                      } else {
                                        themeIndex = 1;
                                      }
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          title: const Text('Select Theme'),
                                          content: SingleChildScrollView(
                                              child: Column(
                                            children: [
                                              RadioListTile(
                                                  title:
                                                      const Text("Light Mode"),
                                                  value: 0,
                                                  groupValue: themeIndex,
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      print(themeIndex);

                                                      themeIndex = value;
                                                      ThemeService()
                                                          .switchTheme();
                                                    });
                                                  }),
                                              RadioListTile(
                                                  title:
                                                      const Text("Dark Mode"),
                                                  value: 1,
                                                  groupValue: themeIndex,
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      themeIndex = value;
                                                      ThemeService()
                                                          .switchTheme();
                                                    });
                                                  })
                                            ],
                                          )),
                                          actions: <Widget>[
                                            // TextButton(
                                            //   onPressed: () {
                                            //     ThemeService().switchTheme();
                                            //     Navigator.pop(
                                            //         context, 'Cancel');
                                            //   },
                                            //   child: const Text('Cancel'),
                                            // ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    // onPressed: () {

                                    //   //ThemeService().switchTheme();

                                    //   // if (Theme.of(context).brightness ==
                                    //   //     Brightness.dark) {
                                    //   //   Get.changeThemeMode(ThemeMode.light);
                                    //   //   authController.setIsDark(false);
                                    //   // } else {
                                    //   //   Get.changeThemeMode(ThemeMode.dark);
                                    //   //   authController.setIsDark(true);
                                    //   // }
                                    // }
                                    ),
                                TextButton.icon(
                                  icon: Icon(Icons.logout),
                                  label: Text("Logout"),
                                  onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      title: const Text('Log Out?'),
                                      content: const Text(
                                          'Are you sure you want to log out?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.delete<TimeSeriesController>();
                                            Get.delete<
                                                NotificationsController>();
                                            Get.delete<
                                                ListOfSensorsController>();
                                            authController.logout();
                                            ThemeService().deleteColorScheme();
                                            ThemeService().deleteTheme();
                                            Get.changeThemeMode(
                                                ThemeMode.light);
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            LoginPage()),
                                                    (_) => false);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ]),
                  )),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.5 / 100),
                  Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(30))),
                      child: Column(children: [
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),

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
                            value: "${authController.user.value!.phoneNumber}",
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
                        // SizedBox(
                        //     height:
                        //         MediaQuery.of(context).size.height * 0 / 100),
                        Container(
                            height:
                                MediaQuery.of(context).size.height * 15 / 100,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("powered by: ",
                                    style:
                                        TextStyle(fontFamily: 'GothamRounded')),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        1.5 /
                                        100),
                                Container(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              10 /
                                              100,
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              40 /
                                              100),
                                  child: Image.network(
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? authController.colorScheme['light']
                                                  ['companyLightLogo']
                                              .toString()
                                          : authController.colorScheme['dark']
                                                  ['companyDarkLogo']
                                              .toString(),
                                      frameBuilder: (context, child, frame, _) {
                                    if (frame == null) {
                                      // fallback to placeholder
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5 /
                                                100),
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return child;
                                  }),
                                ),
                              ],
                            )),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 3 / 100)
                      ]))
                ]),
          ),
        ));
  }
}
