import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pycnomobile/screens/auth/LoginPage.dart';
import 'package:pycnomobile/theme/GlobalTheme.dart';
import 'package:pycnomobile/theme/ThemeService.dart';
import 'package:pycnomobile/widgets/WelcomePageItem.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    List<Widget> pages = [
      WelcomePageItem(text: "AGRICULTURE SOIL & AMBIENT SENSORS"),
      WelcomePageItem(text: "WATER WASTE MANAGEMENT SYSTEMS"),
      WelcomePageItem(text: "OCEANOGRAPHIC & ENVIRONMENTAL SENSING"),
      WelcomePageItem(text: "SMART HYDROPONIC & NURSERY AUTOMATION"),
    ];

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          // height: double.infinity,
          // width: double.infinity,
          child: PageView(controller: controller, children: pages),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 15 / 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.equalizer,
                  size: MediaQuery.of(context).size.width * 15 / 100),
              SizedBox(
                width: MediaQuery.of(context).size.width * 40 / 100,
                child: Center(
                  child: Text("SENSOR CLUB",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width * 5.5 / 100,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'nulshock')),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 1 / 100,
          child: SmoothPageIndicator(
              controller: controller,
              count: pages.length,
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
          bottom: MediaQuery.of(context).size.height * 15 / 100,
          // left: MediaQuery.of(context).size.width * 1 / 100,
          // right: MediaQuery.of(context).size.width * 1 / 100,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 40 / 100,
            child: ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //   primary: Theme.of(context).colorScheme.primary,
              //   onPrimary: Theme.of(context).colorScheme.primary,
              //   onSurface: Theme.of(context).colorScheme.tertiary,
              // ),
              child: Text('Login',
                  style: TextStyle(
                      fontFamily: 'nulshock',
                      fontSize: MediaQuery.of(context).size.width * 5 / 100)),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 8 / 100,
          // left: MediaQuery.of(context).size.width * 1 / 100,
          // right: MediaQuery.of(context).size.width * 1 / 100,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 75 / 100,
            child: Text(
                "You should've received your login details with our hardware devices.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'GothamRounded',
                    fontSize: MediaQuery.of(context).size.width * 3 / 100)),
          ),
        ),
      ],
    );
  }
}
