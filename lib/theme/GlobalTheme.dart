import 'package:flutter/material.dart';
import 'package:pycnomobile/theme/customColorScheme.dart';
import 'package:pycnomobile/controllers/AuthController.dart';
import 'package:get/get.dart';

var globalTheme = ThemeData(
    colorScheme: defaultColorScheme,
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
      primary: defaultColorScheme.secondary,
      onPrimary: defaultColorScheme.onSecondary,
      elevation: 0,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            primary: defaultColorScheme.onSecondary,
            onSurface: defaultColorScheme.secondary,
            backgroundColor: defaultColorScheme.secondary)),
    primaryColor: defaultColorScheme.primary,
    cardTheme: CardTheme(color: defaultColorScheme.surface, elevation: 0),
    scaffoldBackgroundColor: defaultColorScheme.background,
    textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
    primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)));

ThemeData getTheme(Map? colorScheme, bool isLight) {
  ColorScheme myColorScheme;
  if (colorScheme == null) {
    myColorScheme = defaultColorScheme;
  } else {
    myColorScheme = getColorScheme(colorScheme, isLight);
  }
  return ThemeData(
    colorScheme: myColorScheme,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: myColorScheme.primary),
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: myColorScheme.primary)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      primary: myColorScheme.primary,
      onPrimary: myColorScheme.background,
      onSurface: myColorScheme.background,
      elevation: 0,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            primary: myColorScheme.background,
            onSurface: myColorScheme.background,
            backgroundColor: myColorScheme.background)),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: myColorScheme.primary, // This is a custom color variable
      ),
    ),
    primaryColor: myColorScheme.primary,
    cardTheme: CardTheme(color: myColorScheme.surface, elevation: 0),
    scaffoldBackgroundColor: myColorScheme.background,
    textTheme: TextTheme(bodyText2: TextStyle(color: myColorScheme.primary)),
    primaryTextTheme:
        TextTheme(headline6: TextStyle(color: myColorScheme.primary)),
  );
}
