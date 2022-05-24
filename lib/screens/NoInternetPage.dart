import 'package:flutter/material.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text("No Internet!"),
        Text("Check you connection and try again!"),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            primary: Colors.green,
            onPrimary: Colors.white,
            onSurface: Theme.of(context).colorScheme.tertiary,
          ),
          child: Text('Login',
              style: TextStyle(
                  fontFamily: 'nulshock',
                  fontSize: MediaQuery.of(context).size.width * 5 / 100)),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      ],
    ));
  }
}
