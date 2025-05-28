import 'package:flutter/material.dart';
import '../../../constants.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController passwordController;

  String? fullNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: fullNameController,
            validator: fullNameValidator,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Full Name",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.75,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withAlpha(77),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: passwordController,
            validator: passwordValidator,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.75,
                ),
                child: Icon(
                  Icons.lock_outline,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withAlpha(77),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
