import 'package:flutter/material.dart';
import '../constants.dart';
import 'button_theme.dart';
import 'input_decoration_theme.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme,
    iconTheme: const IconThemeData(color: textColor),
    textTheme: Theme.of(context).textTheme.apply(bodyColor: textColor),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: Colors.red,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: textColor.withOpacity(0.5),
      selectedIconTheme: const IconThemeData(color: primaryColor),
      showUnselectedLabels: true,
    ),
    inputDecorationTheme: lightInputDecorationTheme,
    elevatedButtonTheme: elevatedButtonThemeData,
    outlinedButtonTheme: outlinedButtonTheme,
    textButtonTheme: textButtonThemeData,
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF0D0D0D),
    appBarTheme: appBarTheme,
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      error: Colors.red,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF0D0D0D),
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.white.withOpacity(0.5),
      selectedIconTheme: const IconThemeData(color: primaryColor),
      showUnselectedLabels: true,
    ),
    inputDecorationTheme: darkInputDecorationTheme,
    elevatedButtonTheme: elevatedButtonThemeData,
    outlinedButtonTheme: outlinedButtonTheme,
    textButtonTheme: textButtonThemeData,
  );
}

AppBarTheme appBarTheme = const AppBarTheme(
  centerTitle: true,
  elevation: 0,
  backgroundColor: Colors.transparent,
);
