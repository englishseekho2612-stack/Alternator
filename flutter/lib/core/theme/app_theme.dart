import 'package:flutter/material.dart';

/// Apps Alternator AppTheme Configuration
/// Implements a premium, modern, minimalist Material 3 design philosophy.
class AppTheme {
  AppTheme._();

  // Premium Palette Brand Colors
  static const Color primaryDark = Color(0xFF1E293B); // Slate Blue Dark
  static const Color secondaryDark = Color(0xFF0F172A); // Charcoal Darkest
  static const Color accentColor = Color(0xFF38BDF8); // Sky Blue Accent
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color backgroundDark = Color(0xFF0B0F19);

  static const Color primaryLight = Color(0xFFF8FAFC); // Clean Light Off-White
  static const Color secondaryLight = Color(0xFFE2E8F0); // Light Grey Border
  static const Color textDark = Color(0xFF0F172A);
  static const Color textLight = Color(0xFFF1F5F9);

  /// Light Minimalist Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryDark,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textDark),
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryDark,
        secondary: accentColor,
        surface: Colors.white,
        onSurface: textDark,
        error: Colors.redAccent,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark, letterSpacing: -1.0),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textDark),
        bodyLarge: TextStyle(fontSize: 14, color: Color(0xFF475569)),
      ),
    );
  }

  /// Dark Minimalist Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accentColor,
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textLight),
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: primaryDark,
        surface: surfaceDark,
        onSurface: textLight,
        error: Colors.redAccent,
      ),
      cardTheme: CardTheme(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF334155), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textLight, letterSpacing: -1.0),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textLight),
        bodyLarge: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
      ),
    );
  }
}
