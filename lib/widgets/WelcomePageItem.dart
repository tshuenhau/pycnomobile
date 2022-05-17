import 'package:flutter/material.dart';

class WelcomePageItem extends StatelessWidget {
  WelcomePageItem({Key? key, required this.text}) : super(key: key);
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        //height: double.infinity,
        //width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/welcome_page.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        //color: globalTheme.colorScheme.background,
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 8 / 100),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: MediaQuery.of(context).size.height * 8 / 100),
              // SizedBox(
              //   child: Text("APP NAME",
              //       style: TextStyle(fontWeight: FontWeight.bold)),
              // ),
              SizedBox(height: MediaQuery.of(context).size.height * 30 / 100),
              SizedBox(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 80 / 100,
                        child: Text(text,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: MediaQuery.of(context).size.width *
                                    4.5 /
                                    100,
                                fontFamily: 'nulshock')),
                      ),
                      // SizedBox(
                      //     height: MediaQuery.of(context).size.height * 3 / 100),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 60 / 100,
                      //   child: Text(
                      //       "The technological solution for crop monitoring. Save resources, prevent risk and maximize your production."),
                      // ),
                    ]),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 30 / 100),
            ],
          ),
        )));
  }
}
