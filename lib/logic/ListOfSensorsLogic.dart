import 'package:http/http.dart' as http;
import 'package:pycnomobile/logic/Commons.dart';

class ListOfSensorsLogic {
  static getListOfSensors() async {
    final response = await http.get(Uri.parse(
        'https://portal.pycno.co.uk/api/v2/data/nodelist.json?TK=${token}'));

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to retrieve data"); //Ask UI to reload
    }
  }
}
