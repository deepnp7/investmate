import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color primaryLight = Color(0xFF1A2236);
  static const Color accentLight = Color(0xFF0A9EB8);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A2236);
  static const Color textSecondaryLight = Color(0xFF6C757D);
  static const Color gainLight = Color(0xFF2ED573);
  static const Color lossLight = Color(0xFFFF4757);

  // Dark theme colors
  static const Color primaryDark = Color(0xFF0E1626);
  static const Color accentDark = Color(0xFF00B8D4);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFF8F9FA);
  static const Color textSecondaryDark = Color(0xFFADB5BD);
  static const Color gainDark = Color(0xFF2ED573);
  static const Color lossDark = Color(0xFFFF4757);
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: AppColors.cardLight,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.textPrimaryLight,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: AppColors.textPrimaryLight,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textPrimaryLight,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textSecondaryLight,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.accentLight,
      surface: AppColors.cardLight,
      background: AppColors.backgroundLight,
      error: AppColors.lossLight,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentLight,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColors.accentLight,
      unselectedLabelColor: AppColors.textSecondaryLight,
      indicatorColor: AppColors.accentLight,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: AppColors.cardDark,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.textPrimaryDark,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: AppColors.textPrimaryDark,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textPrimaryDark,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textSecondaryDark,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.accentDark,
      surface: AppColors.cardDark,
      background: AppColors.backgroundDark,
      error: AppColors.lossDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentDark,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColors.accentDark,
      unselectedLabelColor: AppColors.textSecondaryDark,
      indicatorColor: AppColors.accentDark,
    ),
  );
}