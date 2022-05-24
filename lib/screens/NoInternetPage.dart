import 'package:flutter/material.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: MediaQuery.of(context).size.height * 1.5 / 100),
              SizedBox(
                height: MediaQuery.of(context).size.width * 12 / 100,
                width: MediaQuery.of(context).size.width * 18 / 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 1,
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    onSurface: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.transparent)),
                  ),
                  child: Icon(Icons.refresh,
                      size: MediaQuery.of(context).size.width * 8 / 100),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 1.5 / 100),
              Text("No Internet!",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'GothamRounded',
                      fontSize: MediaQuery.of(context).size.width * 3.5 / 100)),
              Text("Check you connection and try again!",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'GothamRounded',
                      fontSize: MediaQuery.of(context).size.width * 3.5 / 100)),
            ],
          )),
    );
  }
}
