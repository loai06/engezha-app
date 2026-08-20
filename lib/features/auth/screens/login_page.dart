import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/field_label.dart';
import '../../../core/widgets/primary_button.dart';
import '../widgets/auth_frame.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFrame(
      children: [
        const SizedBox(height: 22),
        Text(
          'Engezha',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 35,
              ),
        ),
        const SizedBox(height: 6),
        Image.asset(
          'assets/images/logo.png',
          width: 160,
          height: 160,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 28),
        const FieldLabel('Email'),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.mail_outline_rounded),
          ),
        ),
        const FieldLabel('Password'),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
        ),
        const SizedBox(height: 30),
        PrimaryButton(
          label: 'Login',
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            AppRoutes.planner,
          ),
        ),
        const Spacer(),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
            child: const Text("Don't have an account?  Sign Up"),
          ),
        ),
      ],
    );
  }
}
