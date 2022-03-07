import 'package:flutter/material.dart';

//! Need to get the color scheme from the JSON,
var customColorScheme = ColorScheme(
    //! Do API Call to get the JSON and then convert it into a ColorSchemeObject
    brightness: Brightness.light,
    background: Color(0xFFf2f0e1),
    onBackground: Colors.black,
    error: Colors.black,
    onError: Colors.black,
    onPrimary: Color(0xFFe2e2c4),
    onSecondary: Color(0xFFfdfdf5),
    onTertiary: Color(0xFFfdfdf5),
    onSurface: Color(0xFF252a20),
    primary: Color(0xFF252a20),
    secondary: Color(0xFF6c6c65),
    tertiary: Color(0xFF757c49),
    surface: Color(0xFFfffcf3));

Color hexToColor(String code) {
  print(code);
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

ColorScheme getColorScheme(Map colorScheme, bool isLight) {
  print("Getting account colorScheme");
  if (isLight) {
    return ColorScheme(
        brightness: Brightness.light,
        background:
            hexToColor(colorScheme["companyColors1"]["light"]["background"]),
        onBackground: Colors.black,
        error: Colors.black,
        onError: Colors.black,
        onPrimary: Color(0xFFe2e2c4),
        onSecondary: Color(0xFFfdfdf5),
        onTertiary: Color(0xFFfdfdf5),
        onSurface: Color(0xFF252a20),
        primary: hexToColor(colorScheme["companyColors1"]["light"]["primary"]),
        secondary: Color(0xFF6c6c65),
        tertiary: Color(0xFF757c49),
        surface:
            hexToColor(colorScheme["companyColors1"]["light"]["background"]));
  } else {
    return ColorScheme(
        brightness: Brightness.light,
        background:
            hexToColor(colorScheme["companyColors1"]["dark"]["background"]),
        onBackground: Colors.black,
        error: Colors.black,
        onError: Colors.black,
        onPrimary: Color(0xFFe2e2c4),
        onSecondary: Color(0xFFfdfdf5),
        onTertiary: Color(0xFFfdfdf5),
        onSurface: Color(0xFF252a20),
        primary: hexToColor(colorScheme["companyColors1"]["dark"]["primary"]),
        secondary: Color(0xFF6c6c65),
        tertiary: Color(0xFF757c49),
        surface: hexToColor(colorScheme["companyColors1"]["dark"]["primary"]));
  }
}
