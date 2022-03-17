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
    final styleActive = TextStyle(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.90));
    final styleHint = TextStyle(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.65));
    final TextEditingController textController = new TextEditingController();

    textController.text = controller.searchController.value;
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        // borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        // border: Border.all(
        //   color: Colors.black26.withOpacity(0.05),
        // ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 5 / 100,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.75),
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
                        print("focs");
                        textController.clear();
                        controller.searchController.value = "";
                        controller.searchListOfSensors();
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
