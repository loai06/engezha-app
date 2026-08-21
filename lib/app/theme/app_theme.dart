import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = isDark
        ? const ColorScheme.dark(
            primary: Colors.white,
            onPrimary: Colors.black,
            primaryContainer: Color(0xFF343434),
            onPrimaryContainer: Colors.white,
            secondary: Colors.white,
            onSecondary: Colors.black,
            secondaryContainer: Color(0xFF343434),
            onSecondaryContainer: Colors.white,
            surface: Color(0xFF1C1C1C),
            onSurface: Colors.white,
            onSurfaceVariant: Colors.white70,
            outline: Colors.white70,
            outlineVariant: Colors.white38,
            error: Color(0xFFFF6B6B),
            onError: Colors.black,
          )
        : const ColorScheme.light(
            primary: Colors.black,
            onPrimary: Colors.white,
            primaryContainer: Colors.black,
            onPrimaryContainer: Colors.white,
            secondary: Colors.black,
            onSecondary: Colors.white,
            secondaryContainer: Color(0xFFE5E7EB),
            onSecondaryContainer: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
            error: Color(0xFFBA1A1A),
            onError: Colors.white,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      fontFamily: 'inter',
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.black,
        foregroundColor: Colors.white,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: isDark ? Colors.white : Colors.black,
        circularTrackColor:
            isDark ? const Color(0xFF343434) : const Color(0xFFE5E7EB),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1C1C1C) : Colors.white,
        indicatorColor:
            isDark ? const Color(0xFF343434) : const Color(0xFFE5E7EB),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);

          return IconThemeData(
            color: selected
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? Colors.white70 : Colors.black54),
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1C1C1C) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : const Color(0xFFE5E7EB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white : Colors.black,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
