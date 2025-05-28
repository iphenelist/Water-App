import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../services/auth_service.dart';
import '../splash/transition_splash.dart';
import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null;
      });

      // Get auth service
      final authService = Provider.of<AuthService>(context, listen: false);

      // Attempt login
      authService
          .login(
            fullName: _fullNameController.text,
            password: _passwordController.text,
          )
          .then((success) {
            if (!mounted) return;

            if (success) {
              // Show transition splash before navigating to home screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => TransitionSplash(
                        message: "Welcome back, ${_fullNameController.text}!",
                        onFinished: () {
                          Navigator.pushReplacementNamed(
                            context,
                            homeScreenRoute,
                          );
                        },
                      ),
                ),
              );
            } else {
              setState(() {
                _errorMessage =
                    authService.errorMessage ??
                    "Login failed. Please try again.";
              });
            }
          })
          .catchError((e) {
            if (!mounted) return;

            setState(() {
              _errorMessage = "Error: $e";
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.35,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Image.asset(
                      'assets/images/water_drop.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Water Management App",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Log in with your full name and password to access your dashboard.",
                  ),
                  const SizedBox(height: defaultPadding),
                  LoginForm(
                    formKey: _formKey,
                    fullNameController: _fullNameController,
                    passwordController: _passwordController,
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Align(
                    child: TextButton(
                      child: const Text("Forgot password?"),
                      onPressed: () {
                        // Handle forgot password
                      },
                    ),
                  ),
                  SizedBox(
                    height:
                        size.height > 700 ? size.height * 0.05 : defaultPadding,
                  ),
                  authService.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        onPressed: _handleLogin,
                        child: const Text("Log in"),
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, signupScreenRoute);
                        },
                        child: const Text("Sign up"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
