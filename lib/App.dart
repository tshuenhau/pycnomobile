import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/controllers/NotificationsController.dart';
import 'package:pycnomobile/screens/AccountPage.dart';
import 'package:pycnomobile/screens/AlertsPage.dart';
import 'package:pycnomobile/screens/SensorListPage.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);
  // final AuthState authState;
  final AuthController authController = Get.put(AuthController());

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late bool isLoggedIn;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  NotificationsController controller = Get.put(NotificationsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getNotifications();

    if (widget.authController.isLoggedIn.value == AuthState.loggedIn) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
  }

  void reset() {
    setState(() {
      isLoggedIn = false;
      print("reset");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

//Screens for each nav items.
  List<Widget> _navScreens() {
    return [
      //TodayPage(),
      SensorListPage(),
      //MapPage(),
      AlertsPage(),
      AccountPage(resetFunction: reset),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      // PersistentBottomNavBarItem(
      //   icon: Icon(Icons.calendar_today),
      //   title: 'Today',
      // ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.sensor_window),
        title: 'Sensors',
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        inactiveColorPrimary: Theme.of(context).primaryColor,
      ),
      // PersistentBottomNavBarItem(
      //   icon: Icon(Icons.map),
      //   title: 'Map',
      // ),
      PersistentBottomNavBarItem(
        //TODO: Notification counter
        icon: Obx(() => Badge(
            badgeContent: Text(controller.alertCounter.value.toString()),
            badgeColor: controller.isSevere.value ? Colors.red : Colors.amber,
            child: Icon(Icons.notifications))),
        title: 'Alerts',
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        inactiveColorPrimary: Theme.of(context).primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: 'Account',
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        inactiveColorPrimary: Theme.of(context).primaryColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _navScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Theme.of(context)
            .scaffoldBackgroundColor, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style3, // Choose the nav bar style with this property.
      ),
    );
  }
}
