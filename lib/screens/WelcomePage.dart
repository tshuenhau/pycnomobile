import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';
import 'package:pycnomobile/theme/GlobalTheme.dart';
import 'package:pycnomobile/theme/ThemeService.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          // height: double.infinity,
          // width: double.infinity,
          child: PageView(controller: controller, children: [
            Container(
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
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 8 / 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 8 / 100),
                      SizedBox(
                        child: Text("APP NAME",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 30 / 100),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    40 /
                                    100,
                                child: Text(
                                    "Monitoring has never been this simple",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      3 /
                                      100),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    60 /
                                    100,
                                child: Text(
                                    "The technological solution for crop monitoring. Save resources, prevent risk and maximize your production."),
                              ),
                            ]),
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 30 / 100),
                    ],
                  ),
                ))),
            Container(
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
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 8 / 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 8 / 100),
                      SizedBox(
                        child: Text("APP NAME",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 30 / 100),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    60 /
                                    100,
                                child: Text(
                                    "The perfect solution for consultants and farmers who want to...",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      3 /
                                      100),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    80 /
                                    100,
                                child: Text(
                                    "monitor water needs, prevent production risk and improve productivity ensuring crop health and quality."),
                              ),
                            ]),
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 30 / 100),
                    ],
                  ),
                ))),
          ]),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 7.5 / 100,
          child: SmoothPageIndicator(
              controller: controller,
              count: 2,
              effect: ScrollingDotsEffect(
                activeStrokeWidth: 2,
                activeDotScale: 1.2,
                spacing: MediaQuery.of(context).size.width * 2 / 100,
                dotHeight: MediaQuery.of(context).size.width * 2 / 100,
                dotWidth: MediaQuery.of(context).size.width * 2 / 100,
                dotColor: Color.fromARGB(255, 201, 201, 201),
                activeDotColor: Colors.white,
              )),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 1 / 100,
          // left: MediaQuery.of(context).size.width * 1 / 100,
          // right: MediaQuery.of(context).size.width * 1 / 100,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 90 / 100,
            child: ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //   primary: Theme.of(context).colorScheme.primary,
              //   onPrimary: Theme.of(context).colorScheme.primary,
              //   onSurface: Theme.of(context).colorScheme.tertiary,
              // ),
              child: Text('Login'),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ),
        ),
      ],
    );
  }
}
