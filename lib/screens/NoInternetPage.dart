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
              Icon(Icons.signal_wifi_bad,
                  color: Colors.black.withOpacity(0.85),
                  size: MediaQuery.of(context).size.width * 15 / 100),
              SizedBox(height: MediaQuery.of(context).size.height * 3.5 / 100),

              Text("WHOOPS!",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GothamRounded',
                      fontSize: MediaQuery.of(context).size.width * 7.5 / 100)),
              Text("No Internet connection!",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GothamRounded',
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 4 / 100)),
              Text("Please check you connection and try again!",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GothamRounded',
                      fontSize: MediaQuery.of(context).size.width * 3.5 / 100)),
              SizedBox(height: MediaQuery.of(context).size.height * 3.5 / 100),

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
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 100 / 100),
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
            ],
          )),
    );
  }
}
