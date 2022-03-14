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

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late bool isLoggedIn;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  final AuthController authController = Get.find();

  NotificationsController controller = Get.put(NotificationsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getTheme(authController.user.value?.colorScheme, true)
    controller.getNotifications();
    if (authController.isLoggedIn.value == AuthState.loggedIn) {
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
          activeColorPrimary: Theme.of(context).colorScheme.tertiary,
          inactiveColorPrimary: Theme.of(context).primaryColor,
          routeAndNavigatorSettings:
              RouteAndNavigatorSettings(initialRoute: '/sensors')),
      // PersistentBottomNavBarItem(
      //   icon: Icon(Icons.map),
      //   title: 'Map',
      // ),
      PersistentBottomNavBarItem(
        //TODO: Notification counter
        icon: Obx(() => Badge(
            badgeContent: Text(
              controller.alertCounter.value.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            animationType: BadgeAnimationType.slide,
            // position: BadgePosition.topEnd(
            //     end: -MediaQuery.of(context).size.width * 3 / 100,
            //     top: -MediaQuery.of(context).size.height * 1.5 / 100),
            badgeColor: controller.isSevere.value
                ? Colors.red
                : Color.fromARGB(255, 151, 91, 1),
            showBadge: controller.alertCounter.value > 0 ? true : false,
            child: Icon(Icons.notifications))),
        title: 'Alerts',
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        inactiveColorPrimary: Theme.of(context).primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: 'Account',
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        inactiveColorPrimary: Theme.of(context).primaryColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
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
            colorBehindNavBar: Theme.of(context).colorScheme.background,
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
          navBarStyle: NavBarStyle
              .style3, // Choose the nav bar style with this property.
          onItemSelected: (int i) {
            authController.currentTab.value = i;
          },
        ),
      ),
    );
  }
}
