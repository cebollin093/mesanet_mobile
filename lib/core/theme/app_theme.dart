import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF123B6D);
  static const Color secondaryColor = Color(0xFF1E5A94);
  static const Color accentColor = Color(0xFFF28C28);

  static const Color backgroundColor = Color(0xFFD0E2EF);
  static const Color lightBlueColor = Color(0xFFD7E7F2);

  static const Color textColor = Color(0xFF1F2937);
  static const Color secondaryTextColor = Color(0xFF64748B);

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: accentColor,
      onSecondary: Colors.white,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      surface: Colors.white,
      onSurface: textColor,
    ),

    scaffoldBackgroundColor: backgroundColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(
        color: secondaryTextColor,
      ),
      prefixIconColor: primaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide(
          color: Color(0xFFB8D0E2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(
          double.infinity,
          52,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: primaryColor,
      indicatorColor: accentColor,
      elevation: 4,

      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),

      iconTheme: WidgetStatePropertyAll(
        IconThemeData(
          color: Colors.white,
        ),
      ),
    ),
  );
}