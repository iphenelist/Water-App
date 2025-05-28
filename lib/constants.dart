import 'package:flutter/material.dart';

// Colors
const primaryColor = Color(0xFF3D85C6);
const secondaryColor = Color(0xFF73B1E8);
const bgColor = Color(0xFFF5F5F5);
const textColor = Color(0xFF333333);
const lightTextColor = Color(0xFF666666);
const borderColor = Color(0xFFDDDDDD);

// Padding
const defaultPadding = 16.0;
const defaultBorderRadius = 12.0;

// Validators
String? Function(String?) emaildValidator = (value) {
  if (value!.isEmpty) {
    return "Please enter your email";
  }
  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
    return "Please enter a valid email";
  }
  return null;
};

String? Function(String?) passwordValidator = (value) {
  if (value!.isEmpty) {
    return "Please enter your password";
  }
  if (value.length < 6) {
    return "Password must be at least 6 characters";
  }
  return null;
};

String? Function(String?) nameValidator = (value) {
  if (value!.isEmpty) {
    return "Please enter your name";
  }
  return null;
};

// User Types
enum UserType {
  customer,
  researcher,
}

// Route Names
const String splashScreenRoute = "/splash";
const String onboardingScreenRoute = "/onboarding";
const String loginScreenRoute = "/login";
const String signupScreenRoute = "/signup";
const String homeScreenRoute = "/home";
const String customerDashboardRoute = "/customer-dashboard";
const String researcherDashboardRoute = "/researcher-dashboard";
const String profileScreenRoute = "/profile";
