import 'package:flutter/material.dart';
import 'package:pycnomobile/theme/CustomColorScheme.dart';

var globalTheme = ThemeData(
    colorScheme: customColorScheme,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        // This will be applied to the "back" icon
        iconTheme: IconThemeData(color: Colors.black),
        // This will be applied to the action icon buttons that locates on the right side
        actionsIconTheme: IconThemeData(color: Colors.black),
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      primary: customColorScheme.secondary,
      onPrimary: customColorScheme.onSecondary,
      elevation: 0,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            primary: customColorScheme.onSecondary,
            onSurface: customColorScheme.secondary,
            backgroundColor: customColorScheme.secondary)),
    primaryColor: customColorScheme.primary,
    cardTheme: CardTheme(color: customColorScheme.surface, elevation: 0),
    scaffoldBackgroundColor: customColorScheme.background,
    textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
    primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)));

ThemeData getTheme(Map? colorScheme, bool isLight) {
  print("Getting account theme");
  print(colorScheme);

  ColorScheme myColorScheme;
  if (colorScheme == null) {
    myColorScheme = customColorScheme;
  } else {
    myColorScheme = getColorScheme(colorScheme, isLight);
  }
  return ThemeData(
      colorScheme: myColorScheme,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          actionsIconTheme: IconThemeData(color: Colors.black),
          centerTitle: false,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        primary: myColorScheme.secondary,
        onPrimary: myColorScheme.onSecondary,
        elevation: 0,
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              primary: myColorScheme.onSecondary,
              onSurface: myColorScheme.secondary,
              backgroundColor: myColorScheme.secondary)),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Colors.white, // This is a custom color variable
        ),
      ),
      primaryColor: myColorScheme.primary,
      cardTheme: CardTheme(color: myColorScheme.surface, elevation: 0),
      scaffoldBackgroundColor: myColorScheme.background,
      textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
      primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)));
}
