import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pycnomobile/screens/AccountPage.dart';
import 'package:pycnomobile/screens/AlertsPage.dart';
import 'package:pycnomobile/screens/MapPage.dart';
import 'package:pycnomobile/screens/SensorListPage.dart';
import 'package:pycnomobile/screens/TodayPage.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

//Screens for each nav items.
  List<Widget> _NavScreens() {
    return [
      //TodayPage(),
      SensorListPage(),
      //MapPage(),
      AlertsPage(),
      AccountPage(),
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
      ),
      // PersistentBottomNavBarItem(
      //   icon: Icon(Icons.map),
      //   title: 'Map',
      // ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notifications),
        title: 'Alerts',
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: 'Account',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _NavScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
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
