import 'package:flutter/material.dart';
import 'package:pycnomobile/controllers/ListOfSensorsController.dart';
import 'package:get/get.dart';

class Search extends StatelessWidget {
  final String hintText;
  final ListOfSensorsController controller = Get.find();

  Search({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final TextEditingController textController = new TextEditingController();
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height * 5 / 100,
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.black26),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Obx(
          () => TextField(
            controller: textController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: controller.searchController.value.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        textController.clear();
                        controller.searchController.value = "";
                        controller.searchListOfSensors();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    )
                  : null,
              hintText: hintText,
              border: InputBorder.none,
            ),
            style: controller.searchController.value.isEmpty
                ? styleHint
                : styleActive,
            onChanged: (text) {
              controller.searchController.value = text;
              controller.searchListOfSensors();
            },
          ),
        ),
      ),
    );
  }
}
