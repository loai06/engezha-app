import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const _darkModeKey = 'dark_mode';

  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_darkModeKey);
    if (saved != null && mounted) {
      setState(() => _darkMode = saved);
    }
  }

  Future<void> _setDarkMode(bool value) async {
    setState(() => _darkMode = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      darkMode: _darkMode,
      setDarkMode: _setDarkMode,
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
