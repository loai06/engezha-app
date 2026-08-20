import 'package:flutter/material.dart';

import '../features/auth/screens/login_page.dart';
import '../features/auth/screens/signup_page.dart';
import '../features/auth/widgets/auth_gate.dart';
import 'routes.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

class EngezhaApp extends StatefulWidget {
  const EngezhaApp({super.key});

  @override
  State<EngezhaApp> createState() => _EngezhaAppState();
}

class _EngezhaAppState extends State<EngezhaApp> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      darkMode: _darkMode,
      setDarkMode: (value) => setState(() => _darkMode = value),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Engezha',
        themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const AuthGate(),
        routes: {
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.signup: (_) => const SignUpPage(),
        },
      ),
    );
  }
}
