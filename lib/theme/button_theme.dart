import 'package:flutter/material.dart';
import '../constants.dart';

ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 0,
    minimumSize: const Size(double.infinity, 48),
    shape: const StadiumBorder(),
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
);

TextButtonThemeData textButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: primaryColor,
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
);

OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    minimumSize: const Size(double.infinity, 48),
    shape: const StadiumBorder(),
    side: const BorderSide(color: primaryColor),
    foregroundColor: primaryColor,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
);
