import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("ERROR PAGE");
    return Center(child: Text("No internet!"));
  }
}
