import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../services/auth_service.dart';
import '../splash/transition_splash.dart';
import 'components/signup_form.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  UserType _selectedUserType = UserType.customer;
  bool _agreeToTerms = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        setState(() {
          _errorMessage = "Please agree to the terms and conditions";
        });
        return;
      }

      setState(() {
        _errorMessage = null;
      });

      // Get auth service
      final authService = Provider.of<AuthService>(context, listen: false);

      // Attempt signup
      authService
          .signUp(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            userType: _selectedUserType,
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
                        message:
                            "Welcome, ${_nameController.text}!\nYour account has been created successfully.",
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
                    "Signup failed. Please try again.";
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
              height: size.height * 0.3,
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
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Create Account",
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
                    "Let's get started!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Please enter your information to create an account.",
                  ),
                  const SizedBox(height: defaultPadding),
                  SignupForm(
                    formKey: _formKey,
                    nameController: _nameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),
                  const SizedBox(height: defaultPadding),
                  const Text(
                    "Select account type:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<UserType>(
                          title: const Text("Customer"),
                          value: UserType.customer,
                          groupValue: _selectedUserType,
                          onChanged: (UserType? value) {
                            setState(() {
                              _selectedUserType = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<UserType>(
                          title: const Text("Researcher"),
                          value: UserType.researcher,
                          groupValue: _selectedUserType,
                          onChanged: (UserType? value) {
                            setState(() {
                              _selectedUserType = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "I agree to the ",
                            children: [
                              TextSpan(
                                text: "Terms of Service",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: null, // Add tap gesture if needed
                              ),
                              const TextSpan(text: " and Privacy Policy"),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                  const SizedBox(height: defaultPadding),
                  authService.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        onPressed: _handleSignup,
                        child: const Text("Sign Up"),
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, loginScreenRoute);
                        },
                        child: const Text("Log in"),
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
