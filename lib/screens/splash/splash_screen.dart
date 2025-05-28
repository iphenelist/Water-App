import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask to avoid calling setState during build
    Future.microtask(() => _checkAuth());
  }

  Future<void> _checkAuth() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      // Start a timer to ensure splash screen is shown for at least 2 seconds
      final splashTimer = Future.delayed(const Duration(seconds: 2));

      // Initialize auth service
      final authInit = authService.initialize();

      // Wait for both the timer and auth initialization to complete
      await Future.wait([splashTimer, authInit]);

      if (mounted) {
        if (authService.isLoggedIn) {
          Navigator.pushReplacementNamed(context, homeScreenRoute);
        } else {
          Navigator.pushReplacementNamed(context, loginScreenRoute);
        }
      }
    } catch (e) {
      debugPrint('Error during authentication check: $e');
      // Still wait for the minimum splash time even if there's an error
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushReplacementNamed(context, loginScreenRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Image.asset(
              'assets/images/water_drop.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              "Water Management App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
