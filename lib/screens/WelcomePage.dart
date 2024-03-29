import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:Sensr/screens/auth/LoginPage.dart';
import 'package:Sensr/theme/GlobalTheme.dart';
import 'package:Sensr/theme/ThemeService.dart';
import 'package:Sensr/widgets/WelcomePageItem.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController controller = PageController();

  final List _allAsset = [
    ///tabbar
    "assets/images/vineyard.jpg",
    "assets/images/water_treatment.jpg",
    "assets/images/space.jpg",
    "assets/images/rov.jpg",
    "assets/images/potatoes_in_space_greenhouse.jpg"
  ];
  int index = 0;
  List<Widget> pages = [
    WelcomePageItem(
        text: "AGRICULTURE SOIL & AMBIENT SENSORS",
        image: AssetImage("assets/images/vineyard.jpg")),
    WelcomePageItem(
        text: "WATER WASTE MANAGEMENT SYSTEMS",
        image: AssetImage("assets/images/water_treatment.jpg")),
    WelcomePageItem(
        text: "HOSTILE ENVIRONMENT SENSOR SYSTEMS",
        image: AssetImage("assets/images/space.jpg")),
    WelcomePageItem(
        text: "OCEANOGRAPHIC & ENVIRONMENTAL SENSING",
        image: AssetImage("assets/images/rov.jpg")),
    WelcomePageItem(
        text: "SMART HYDROPONIC & NURSERY AUTOMATION",
        image: AssetImage("assets/images/potatoes_in_space_greenhouse.jpg")),
  ];
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    for (var asset in _allAsset) {
      precacheImage(AssetImage(asset), context);
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          // height: double.infinity,
          // width: double.infinity,
          child: PageView(
            allowImplicitScrolling: true,
            controller: controller,
            children: pages,
            onPageChanged: (i) {
              print("onpageChanged: index" + index.toString());
              setState(() {
                index = i;
              });
            },
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 15 / 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon(Icons.equalizer,
              //     size: MediaQuery.of(context).size.width * 15 / 100),
              Image(
                  width: MediaQuery.of(context).size.width * 15 / 100,
                  height: MediaQuery.of(context).size.width * 15 / 100,
                  image: AssetImage("assets/images/app_logo.png")),
              SizedBox(
                width: MediaQuery.of(context).size.width * 40 / 100,
                child: Center(
                  child: Text("Sensr",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              MediaQuery.of(context).size.width * 5.5 / 100,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'nulshock',
                          shadows: [
                            Shadow(
                                color: Colors.black.withOpacity(0.9),
                                offset: const Offset(10, 5),
                                blurRadius: 30),
                          ])),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 4 / 100,
          child: SmoothPageIndicator(
              controller: controller,
              count: pages.length,
              effect: ScrollingDotsEffect(
                activeStrokeWidth: 2,
                activeDotScale: 1.6,
                spacing: MediaQuery.of(context).size.width * 2 / 100,
                dotHeight: MediaQuery.of(context).size.width * 2 / 100,
                dotWidth: MediaQuery.of(context).size.width * 2 / 100,
                dotColor: Color.fromARGB(255, 201, 201, 201),
                activeDotColor: Colors.white,
              )),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 18 / 100,
          // left: MediaQuery.of(context).size.width * 1 / 100,
          // right: MediaQuery.of(context).size.width * 1 / 100,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 40 / 100,
            child: ElevatedButton(
              style: index < 3
                  ? ElevatedButton.styleFrom(
                      elevation: 1,
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      onSurface: Theme.of(context).colorScheme.tertiary,
                    )
                  : ElevatedButton.styleFrom(
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
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 11 / 100,
          // left: MediaQuery.of(context).size.width * 1 / 100,
          // right: MediaQuery.of(context).size.width * 1 / 100,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 75 / 100,
            child: Text(
                "You should've received your login details with our hardware devices.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontFamily: 'GothamRounded',
                    fontSize: MediaQuery.of(context).size.width * 3 / 100)),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0 / 100,
          child: Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 3 / 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("MADE WITH",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontFamily: 'GothamRounded',
                          fontSize:
                              MediaQuery.of(context).size.width * 3 / 100)),
                  SizedBox(width: MediaQuery.of(context).size.width * 1 / 100),
                  Icon(Icons.favorite,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.width * 3 / 100),
                  SizedBox(width: MediaQuery.of(context).size.width * 1 / 100),
                  Text("BY DEEP ORBITAL",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontFamily: 'GothamRounded',
                          fontSize:
                              MediaQuery.of(context).size.width * 3 / 100))
                ],
              )),
        )
      ],
    );
  }
}
