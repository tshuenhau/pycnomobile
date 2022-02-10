import 'package:flutter/material.dart';
import 'package:pycnomobile/theme/CustomColorScheme.dart';

class GlobalTheme {
  final globalTheme = ThemeData(
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
        primary: customColorScheme.surface,
        onPrimary: customColorScheme.secondary,
        elevation: 0,
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              primary: customColorScheme.surface,
              onSurface: customColorScheme.secondary,
              backgroundColor: customColorScheme.secondary)),
      primaryColor: customColorScheme.primary,
      cardTheme: CardTheme(color: customColorScheme.surface, elevation: 0),
      scaffoldBackgroundColor: customColorScheme.background,
      textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
      primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)));
}
