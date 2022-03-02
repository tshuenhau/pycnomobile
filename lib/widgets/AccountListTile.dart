import 'package:flutter/material.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:pycnomobile/theme/GlobalTheme.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    Key? key,
    required this.title,
    required this.value,
    required this.authController,
  }) : super(key: key);

  final AuthController authController;
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          // side: BorderSide(
          //   color: globalTheme.colorScheme.tertiary.withOpacity(0.20),
          //   width: 1,
          // ),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 5 / 100,
            vertical: MediaQuery.of(context).size.height * 0.55 / 100),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.35 / 100),
          child: ListTile(
              horizontalTitleGap: MediaQuery.of(context).size.width * 5 / 100,
              dense: true,
              leading: SizedBox(
                  width: MediaQuery.of(context).size.width * 25 / 100,
                  child: Text(title,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              title: Text(value),
              trailing: Icon(Icons.edit)),
        ));
  }
}
