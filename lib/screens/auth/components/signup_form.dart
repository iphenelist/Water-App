import 'package:flutter/material.dart';
import '../../../constants.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
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
            controller: nameController,
            validator: nameValidator,
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
            controller: emailController,
            validator: emailValidator,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email address",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.75,
                ),
                child: Icon(
                  Icons.email_outlined,
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
