import 'package:flutter/material.dart';

class ThemeController extends InheritedWidget {
  const ThemeController({
    super.key,
    required this.darkMode,
    required this.setDarkMode,
    required super.child,
  });

  final bool darkMode;
  final ValueChanged<bool> setDarkMode;

  static ThemeController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeController>()!;
  }

  @override
  bool updateShouldNotify(ThemeController oldWidget) {
    return darkMode != oldWidget.darkMode;
  }
}
