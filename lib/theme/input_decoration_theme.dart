import 'package:flutter/material.dart';
import '../constants.dart';

InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
  fillColor: Colors.white,
  filled: true,
  hintStyle: const TextStyle(color: lightTextColor),
  border: outlineInputBorder,
  enabledBorder: outlineInputBorder,
  focusedBorder: focusedOutlineInputBorder,
  errorBorder: errorOutlineInputBorder,
  focusedErrorBorder: errorOutlineInputBorder,
  contentPadding: const EdgeInsets.symmetric(
    horizontal: defaultPadding,
    vertical: defaultPadding,
  ),
);

InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
  fillColor: Colors.black.withOpacity(0.1),
  filled: true,
  hintStyle: const TextStyle(color: Colors.white70),
  border: darkOutlineInputBorder,
  enabledBorder: darkOutlineInputBorder,
  focusedBorder: darkFocusedOutlineInputBorder,
  errorBorder: darkErrorOutlineInputBorder,
  focusedErrorBorder: darkErrorOutlineInputBorder,
  contentPadding: const EdgeInsets.symmetric(
    horizontal: defaultPadding,
    vertical: defaultPadding,
  ),
);

OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(defaultBorderRadius),
  borderSide: const BorderSide(color: borderColor),
);

OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(defaultBorderRadius),
  borderSide: const BorderSide(color: primaryColor),
);

OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(defaultBorderRadius),
  borderSide: const BorderSide(color: Colors.red),
);

OutlineInputBorder darkOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(defaultBorderRadius),
  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
);

OutlineInputBorder darkFocusedOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(defaultBorderRadius),
  borderSide: const BorderSide(color: primaryColor),
);

OutlineInputBorder darkErrorOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(defaultBorderRadius),
  borderSide: const BorderSide(color: Colors.red),
);
