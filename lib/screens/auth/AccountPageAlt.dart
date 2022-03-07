import 'package:flutter/material.dart';
import 'package:pycnomobile/screens/BluetoothPage.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';
import 'package:pycnomobile/screens/AccountDetailsPage.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/widgets/AccountListTile.dart';

class AccountPage extends StatelessWidget {
  AccountPage({Key? key, required this.resetFunction}) : super(key: key);
  Function resetFunction;
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Obx(() => Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: CustomScrollView(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  pinned: true,
                  snap: true,
                  floating: true,
                  expandedHeight: MediaQuery.of(context).size.height * 25 / 100,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 10 / 100,
                        bottom: MediaQuery.of(context).size.height * 2 / 100),
                    title: Text('Username', textAlign: TextAlign.center),
                    background: Stack(fit: StackFit.loose, children: [
                      Positioned(
                        top: MediaQuery.of(context).size.height * 5 / 100,
                        left: MediaQuery.of(context).size.width * 15 / 100,
                        child: Container(
                          child: authController.user.value == null
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
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 6 / 100,
                        right: MediaQuery.of(context).size.width * 7 / 100,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                      ),
                    ]),
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: SizedBox(
                //       height: MediaQuery.of(context).size.height * 3.5 / 100),
                // ),
                // SliverToBoxAdapter(
                //   child: Container(
                //       child: IntrinsicHeight(
                //     child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //           Column(
                //             children: [
                //               authController.user.value == null
                //                   ? CircularProgressIndicator()
                //                   : CircleAvatar(
                //                       radius: 50,
                //                       backgroundImage: authController
                //                                   .user.value!.profilePic !=
                //                               null
                //                           ? NetworkImage(
                //                               "https://pycno.co/${authController.user.value!.profilePic}")
                //                           : null,
                //                       child: authController
                //                                   .user.value!.profilePic ==
                //                               null
                //                           ? Icon(Icons.person, size: 50)
                //                           : null),
                //               SizedBox(
                //                   height: MediaQuery.of(context).size.height *
                //                       2 /
                //                       100),
                //               Text(authController.user.value!.username,
                //                   style: TextStyle(
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: 25)),
                //             ],
                //           ),
                //           Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               mainAxisSize: MainAxisSize.max,
                //               children: [
                //                 TextButton.icon(
                //                     icon: Icon(Icons.radar),
                //                     label: Text("Scan for devices"),
                //                     onPressed: () => Navigator.of(context).push(
                //                         MaterialPageRoute(
                //                             builder: (_) => BluetoothPage()))),
                //                 TextButton.icon(
                //                     icon: Icon(Icons.logout),
                //                     label: Text("Logout"),
                //                     onPressed: () {
                //                       authController.logout();
                //                       Get.reset();
                //                       Navigator.of(context, rootNavigator: true)
                //                           .pushAndRemoveUntil(
                //                               MaterialPageRoute(
                //                                   builder: (_) => LoginPage()),
                //                               (_) => false);
                //                     }),
                //               ]),
                //         ]),
                //   )),
                // ),
                // TextButton.icon(
                //     icon: Icon(Icons.person),
                //     label: Text("Account Details"),
                //     onPressed: () => Navigator.of(context).push(
                //           MaterialPageRoute(
                //               builder: (_) => AccountDetailsPage()),
                //         )),
                SliverToBoxAdapter(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 2.5 / 100),
                ),
                SliverToBoxAdapter(
                  child: Container(
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
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 50 / 100),
                      ])),
                )
              ]),
        ));
  }
}
