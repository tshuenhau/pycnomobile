import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pycnomobile/storage/Preferences.dart';

class AuthController extends GetxController {
  bool isLogin = false;

  login(String username, String password) async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co/login?username=$username&password=$password'));

    if (response.statusCode == 200) {
      //Store token to local storage

      final preferences = await Preferences.getInstance();
      preferences.setToken(
          'LqsxbuIEB8BqUAkXCaXMFfucjbgzDFb3'); //To be changed to dynamic token from reponse
      print("Login successful");

      isLogin = true;
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
    final preferences = await Preferences.getInstance();
    await preferences.deleteToken();
  }
}
