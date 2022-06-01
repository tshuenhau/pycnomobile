import 'package:badges/badges.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:Sensr/controllers/AuthController.dart';
import 'package:Sensr/controllers/NotificationsController.dart';
import 'package:Sensr/controllers/ListOfSensorsController.dart';
import 'package:Sensr/screens/AccountPage.dart';
import 'package:Sensr/screens/AlertsPage.dart';
import 'package:Sensr/screens/SensorListPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Sensr/theme/GlobalTheme.dart';
import 'package:Sensr/theme/ThemeService.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);
  // final AuthState authState;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late bool isLoggedIn;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  final AuthController authController = Get.find();

  NotificationsController controller = Get.put(NotificationsController());
  ListOfSensorsController sensorsController =
      Get.put(ListOfSensorsController());

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
    WidgetsBinding.instance!.addObserver(this);
  }

  Future _refreshData() async {
    await sensorsController.getListOfSensors();
    sensorsController.searchListOfSensors();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      sensorsController.lastPausedTime.value = DateTime.now();
    }
    if (state == AppLifecycleState.resumed &&
        ModalRoute.of(context)!.isCurrent &&
        sensorsController.lastPausedTime.value
            .isBefore(DateTime.now().add(const Duration(seconds: -900)))) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => App()));
      EasyLoading.show(status: "Fetching Sensors...");
      await _refreshData();
      EasyLoading.dismiss();
    }
  }

  void reset() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
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
              style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontWeight: FontWeight.bold),
            ),
            animationType: BadgeAnimationType.slide,
            // position: BadgePosition.topEnd(
            //     end: -MediaQuery.of(context).size.width * 3 / 100,
            //     top: -MediaQuery.of(context).size.height * 1.5 / 100),
            badgeColor: controller.isSevere.value
                ? Colors.red.shade700
                : Theme.of(context).colorScheme.tertiary,
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
    bool isLight = Theme.of(context).brightness == Brightness.light;
    // print("BRIGHTNESS?" +
    //     (Theme.of(context).brightness == Brightness.light).toString());
    final Color accent =
        getTheme(ThemeService().colorScheme, isLight).colorScheme.tertiary;

    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType = EasyLoadingMaskType.custom
      ..backgroundColor = Theme.of(context).colorScheme.background
      ..maskColor = isLight
          ? Theme.of(context).colorScheme.primary.withOpacity(0.35)
          : Theme.of(context).colorScheme.primary.withOpacity(0.05)
      ..displayDuration = const Duration(milliseconds: 1000)
      ..indicatorColor = accent
      ..textColor = accent;

    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          // behavior: SnackBarBehavior.floating,
          // margin:
          //     EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 2),
          content: Text('Tap back again to leave'),
        ),
        child: SafeArea(
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
        ),
      ),
    );
  }
}
