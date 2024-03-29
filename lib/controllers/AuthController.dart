import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:Sensr/storage/Preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:Sensr/model/User.dart';
import 'package:Sensr/App.dart';
import 'dart:convert';
import 'package:Sensr/theme/ThemeService.dart';
import 'package:Sensr/theme/GlobalTheme.dart';
import 'package:Sensr/screens/NoInternetPage.dart';
import 'package:Sensr/env.dart';

enum AuthState { unknown, loggedIn, loggedOut, firstLogin }

class AuthController extends GetxController {
  String token = "";
  Rx<bool> isLightMode = true.obs;
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
    if (isLoggedIn.value != AuthState.firstLogin) {
      isLoggedIn.value = await checkLoggedInStatus();
    }
  }

  Future<AuthState> checkLoggedInStatus() async {
    token = preferences.getToken();
    if (token == "") {
      return AuthState.loggedOut;
    }
    try {
      await getAccount();
      await Future.delayed(Duration(seconds: 3)); //For logo to load
      return AuthState.loggedIn;
    } on SocketException catch (e) {
      Get.to(NoInternetPage(
          message1: "No Internet connection.",
          message2: "Please check you connection and try again."));
      return AuthState.loggedOut;
    } catch (e) {
      return AuthState.loggedOut;
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

    Map<String, dynamic> body = {
      "username": username,
      "password": password,
      "deviceName": deviceModel,
      "deviceID": deviceId
    };

    final response = await http.post(Uri.parse("$API_URL/login"), body: body);
    if (response.statusCode == 200) {
      String tk = jsonDecode(response.body)["tk"];
      token = tk;
      final preferences = await Preferences.getInstance();
      await preferences.setToken(tk);
      await getAccount();
      isLoggedIn.value = AuthState.firstLogin;
      if (user.value != null) {
        ThemeService().saveColorScheme(user.value!.colorScheme);
        ThemeService().saveTheme(true);
        ThemeService().switchTheme();
      }
    } else {
      throw Exception("Unable to login");
    }
  }

  getAccount() async {
    final response =
        await http.get(Uri.parse('$API_URL/data/account.json?TK=$token'));

    if (response.statusCode == 200) {
      user.value = User.fromJson(jsonDecode(response.body)["user"]);
      if (user.value != null) {
        this.colorScheme.value = user.value!.colorScheme;
      }
    } else {
      throw Exception("Unable to get account details");
    }
  }

  Future<void> logout() async {
    //Delete token and send api post request to delete token
    final response =
        await http.get(Uri.parse('$API_URL/data/logout?TK=$token'));
    if (response.statusCode == 200) {
      final preferences = await Preferences.getInstance();
      await preferences.deleteToken();
      this.colorScheme.value = {};
      token = "";
      isLoggedIn.value = AuthState.loggedOut;
      currentTab.value = 0;
      getTheme({}, true);
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
