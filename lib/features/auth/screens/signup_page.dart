import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/field_label.dart';
import '../../../core/widgets/primary_button.dart';
import '../widgets/auth_frame.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFrame(
      children: [
        const SizedBox(height: 25),
        Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 7),
        const Text("Let's get you started", textAlign: TextAlign.center),
        const SizedBox(height: 34),
        ..._fields(),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Sign Up',
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            AppRoutes.planner,
          ),
        ),
        const Spacer(),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Already have an account?  Login'),
          ),
        ),
      ],
    );
  }

  List<Widget> _fields() => const [
        FieldLabel('Full Name'),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            prefixIcon: Icon(Icons.person_outline_rounded),
          ),
        ),
        SizedBox(height: 18),
        FieldLabel('Email'),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.mail_outline_rounded),
          ),
        ),
        SizedBox(height: 18),
        FieldLabel('Password'),
        SizedBox(height: 8),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Create a password',
            prefixIcon: Icon(Icons.lock_outline_rounded),
            suffixIcon: Icon(Icons.visibility_off_outlined),
          ),
        ),
        SizedBox(height: 18),
        FieldLabel('Confirm Password'),
        SizedBox(height: 8),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            prefixIcon: Icon(Icons.lock_outline_rounded),
            suffixIcon: Icon(Icons.visibility_off_outlined),
          ),
        ),
      ];
}
