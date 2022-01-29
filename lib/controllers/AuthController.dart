import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/storage/Preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class AuthController extends GetxController {
  String token = "";
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Rx<bool> isLoggedIn = false.obs;
  var deviceData = <String, dynamic>{};

  onInit() async {
    isLoggedIn.value = await checkLoggedInStatus();
  }

  Future<bool> checkLoggedInStatus() async {
    final preferences = await Preferences.getInstance();
    token = preferences.getToken();
    print(token);
    return token != "";
  }

  login({required String username, required String password}) async {
    print(username);
    print(password);
    final response = await http.post(Uri.parse(
        'https://portal.pycno.co/login?username=$username&password=$password'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Store token to local storage

      final preferences = await Preferences.getInstance();
      preferences.setToken(
          'LqsxbuIEB8BqUAkXCaXMFfucjbgzDFb3'); //To be changed to dynamic token from reponse
      print("Login successful");
    } else {
      throw Exception("Unable to login");
    }
  }

  getAccount(String token) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co/api/v2/data/account.json?TK=$token'));

    if (response.statusCode == 200) {
      print("get account details success");
    } else {
      throw Exception("Unable to get account details");
    }
  }

  void logout() async {
    //Delete token and send api post request to delete token
    final preferences = await Preferences.getInstance();
    await preferences.deleteToken();
    print(preferences.getToken());
  }

  void setDeviceData() async {
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
