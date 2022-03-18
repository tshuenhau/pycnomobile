import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pycnomobile/controllers/ListOfSensorsController.dart';
import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/widgets/SensorsListTile.dart';

class SensorSearchPage extends StatefulWidget {
  const SensorSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SensorSearchPage> createState() => _SensorSearchPageState();
}

var bottomNavigationBar;

class _SensorSearchPageState extends State<SensorSearchPage> {
  late String query = "";

  @override
  void initState() {
    super.initState();
    // search = "";
  }

  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  ListOfSensorsController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final ListOfSensorsController sensorsController =
        Get.put(ListOfSensorsController());

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color:
                Theme.of(context).colorScheme.primary, //change your color here
          ),
          // The search area here
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        /* Clear the search field */
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
                onChanged: (String searchTerms) {},
              ),
            ),
          )),
      body: Center(
        child: ListView.builder(
          itemCount: sensorsController.listOfSensors.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Sensor sensor = sensorsController.listOfSensors[index];
            return SensorsListTile(sensor: sensor);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
