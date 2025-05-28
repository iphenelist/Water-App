import 'package:flutter/material.dart';
import '../../constants.dart';

/// A transition splash screen that can be shown after login/signup
/// to provide a smooth transition to the main app content.
class TransitionSplash extends StatelessWidget {
  final String message;
  final Widget? child;
  final VoidCallback? onFinished;
  final Duration duration;

  const TransitionSplash({
    super.key,
    this.message = "Loading your dashboard...",
    this.child,
    this.onFinished,
    this.duration = const Duration(seconds: 2),
  });

  @override
  Widget build(BuildContext context) {
    // Start the timer when the widget is built
    if (onFinished != null) {
      Future.delayed(duration).then((_) => onFinished!());
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor, secondaryColor],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Water drop image
            Image.asset(
              'assets/images/water_drop.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            
            // App name
            const Text(
              "Water Management App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            
            // Custom message
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            
            // Optional child widget
            if (child != null) ...[
              const SizedBox(height: 30),
              child!,
            ],
          ],
        ),
      ),
    );
  }
}
