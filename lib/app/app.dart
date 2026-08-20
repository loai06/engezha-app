import 'package:flutter/material.dart';

import '../features/auth/screens/login_page.dart';
import '../features/auth/screens/signup_page.dart';
import '../features/planner/models/entry_kind.dart';
import '../features/planner/screens/planner_form.dart';
import '../features/shell/planner_shell.dart';
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
        title: 'Super Planner',
        themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.signup: (_) => const SignUpPage(),
          AppRoutes.planner: (_) => const PlannerShell(),
          AppRoutes.addTask: (_) =>
              const PlannerForm(kind: EntryKind.task),
          AppRoutes.addHabit: (_) =>
              const PlannerForm(kind: EntryKind.habit),
          AppRoutes.editTask: (_) =>
              const PlannerForm(kind: EntryKind.task, editing: true),
          AppRoutes.editHabit: (_) =>
              const PlannerForm(kind: EntryKind.habit, editing: true),
        },
      ),
    );
  }
}
