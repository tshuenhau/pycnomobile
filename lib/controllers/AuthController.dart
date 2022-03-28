import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/storage/Preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:pycnomobile/model/User.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pycnomobile/theme/ThemeService.dart';

enum AuthState { unknown, loggedIn, loggedOut }

class AuthController extends GetxController {
  String token = "";
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Rx<AuthState> isLoggedIn = AuthState.unknown.obs;
  var deviceData = <String, dynamic>{};
  Rx<int> currentTab = 0.obs;
  late Preferences preferences;
  Rxn<User> user = Rxn<User>();
  RxMap<dynamic, dynamic> colorScheme = {}.obs;
  @override
  onInit() async {
    super.onInit();
    preferences = await Preferences.getInstance();
    print(this.colorScheme);
    print(ThemeService().colorScheme);
    // await getTheme();
    // await getIsDark();

    // changeTheme();

    isLoggedIn.value =
        await checkLoggedInStatus() ? AuthState.loggedIn : AuthState.loggedOut;

    // if (isLoggedIn.value == AuthState.loggedIn) {
    //   getAccount();
    // }
  }

  // changeTheme() {
  //   if (isDark.value) {
  //     Get.changeThemeMode(ThemeMode.dark);
  //   } else {
  //     Get.changeThemeMode(ThemeMode.light);
  //   }
  // }

  // Future<void> getTheme() async {
  //   theme.value = preferences.getTheme();
  // }

  // Future<void> getIsDark() async {
  //   isDark.value = preferences.getIsDark();
  // }

  // Future<void> setIsDark(bool isDark) async {
  //   final preferences = await Preferences.getInstance();
  //   preferences.setIsDark(isDark);
  // }

  Future<bool> checkLoggedInStatus() async {
    token = preferences.getToken();
    if (token == "") {
      return false;
    }

    try {
      await getAccount();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> login(
      {required String username, required String password}) async {
    String deviceModel = "";
    String deviceId = "";
    if (Platform.isAndroid) {
      deviceModel = deviceData["model"];
      deviceId = deviceData["id"];
    } else if (Platform.isIOS) {
      deviceModel = deviceData["name"];
      deviceId = deviceData["identifierForVendor"];
    }
    // final response = await http.post(Uri.parse(
    //     'https://portal.pycno.co/login?username=$username&password=$password'));
    Map<String, dynamic> body = {
      "username": username,
      "password": password,
      "deviceName": deviceModel,
      "deviceID": deviceId
    };

    final response = await http
        .post(Uri.parse("https://stage.pycno.co/api/v2/login"), body: body);
    if (response.statusCode == 200) {
      String tk = jsonDecode(response.body)["tk"];
      token = tk;
      final preferences = await Preferences.getInstance();
      await preferences.setToken(tk);
      print("Login successful! Token: $token");
      await getAccount();
      if (user.value != null) {
        // await preferences.setTheme(user.value!.colorScheme);

        ThemeService().saveColorScheme(user.value!.colorScheme);
        print("SAVE THEME!");
        ThemeService().saveTheme(true);
        ThemeService().switchTheme();
      }
    } else {
      throw Exception("Unable to login");
    }
  }

  getAccount() async {
    final response = await http.get(
        Uri.parse('https://stage.pycno.co/api/v2/data/account.json?TK=$token'));

    if (response.statusCode == 200) {
      user.value = User.fromJson(jsonDecode(response.body)["user"]);
      if (user.value != null) {
        this.colorScheme.value = user.value!.colorScheme;
      }

      update();
    } else {
      throw Exception("Unable to get account details");
    }
  }

  void logout() async {
    //Delete token and send api post request to delete token
    final response = await http
        .get(Uri.parse('https://stage.pycno.co/api/v2/data/logout?TK=$token'));
    if (response.statusCode == 200) {
      final preferences = await Preferences.getInstance();
      await preferences.deleteToken();
      this.colorScheme.value = {};
      token = "";
      isLoggedIn.value = AuthState.loggedOut;
      currentTab.value = 0;
    } else {
      throw Exception("Unable to logout. Try again.");
    }
  }

  Future<void> setDeviceData() async {
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
