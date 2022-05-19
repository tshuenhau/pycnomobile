import 'package:flutter/material.dart';

//! Need to get the color scheme from the JSON,
var defaultColorScheme = ColorScheme(
    brightness: Brightness.light,
    background: Colors.white,
    onBackground: Colors.black,
    error: Colors.black,
    onError: Colors.black,
    onPrimary: Color(0xFFe2e2c4),
    onSecondary: Color(0xFFfdfdf5),
    onTertiary: Color(0xFFfdfdf5),
    onSurface: Colors.white,
    primary: Colors.black,
    secondary: Colors.black,
    tertiary: Colors.black,
    surface: Colors.white.withOpacity(0.85));

Color hexToColor(String code) {
  // print(code);
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

ColorScheme getColorScheme(Map colorScheme, bool isLight) {
  if (colorScheme.isEmpty) {
    return defaultColorScheme;
  }
  if (isLight) {
    return ColorScheme(
        brightness: Brightness.light,
        background: hexToColor(colorScheme["light"]["companyLightBackground"]),
        onBackground: Colors.black,
        error: Colors.black,
        onError: Colors.black,
        onPrimary: Color(0xFFe2e2c4),
        onSecondary: Color(0xFFfdfdf5),
        onTertiary: Color(0xFFfdfdf5),
        onSurface: Color(0xFF252a20),
        primary: Colors.black,
        secondary: Colors.black,
        tertiary: hexToColor(colorScheme["light"]["companyLightAccent"]),
        surface: Colors.white.withOpacity(0.85));
  } else {
    return ColorScheme(
        brightness: Brightness.dark,
        background: hexToColor(colorScheme["dark"]["companyDarkBackground"]),
        onBackground: Colors.black,
        error: Colors.white,
        onError: Colors.white,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onTertiary: Colors.black,
        onSurface: Colors.white,
        primary: Colors.white,
        secondary: Colors.white,
        tertiary: hexToColor(colorScheme["dark"]["companyDarkAccent"]),
        surface: Colors.black.withOpacity(0.85));
  }
}
