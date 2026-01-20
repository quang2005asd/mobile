import 'package:flutter/material.dart';

class AppColors {
  // Apple-inspired minimal colors
  static const primary = Color(0xFF0A84FF); // Apple Blue
  static const primaryLight = Color(0xFF5AC8FA);
  static const primaryDark = Color(0xFF0051D5);
  static const success = Color(0xFF34C759); // Apple Green
  static const warning = Color(0xFFFF9500); // Apple Orange
  static const danger = Color(0xFFFF3B30); // Apple Red
  static const background = Color(0xFFFAFAFA); // Light gray
  static const surface = Color(0xFFFFFFFF); // White
  static const text = Color(0xFF000000); // Pure black
  static const textLight = Color(0xFF808080); // Gray
  static const divider = Color(0xFFE5E5EA); // Light divider
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.danger,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: false,
      foregroundColor: AppColors.text,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.primary,
      surface: const Color(0xFF1C1C1E),
      background: const Color(0xFF000000),
      error: AppColors.danger,
    ),
    scaffoldBackgroundColor: const Color(0xFF000000),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1C1C1E),
      elevation: 0,
      centerTitle: false,
      foregroundColor: Colors.white,
    ),
  );
}
