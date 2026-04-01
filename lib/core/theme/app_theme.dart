import 'package:flutter/material.dart';

class AppTheme {
  // --- Brand Colors ---
  static const primary = Color(0xFF1E9E78);
  static const primaryLight = Color(0xFFE0F4EC);
  static const primaryDark = Color(0xFF084D3C);

  static const secondary = Color(0xFF2480CE);
  static const secondaryLight = Color(0xFFE3F1FB);
  static const secondaryDark = Color(0xFF0A3F72);

  static const accent = Color(0xFFC07818);
  static const accentLight = Color(0xFFFEF3E2);

  static const success = Color(0xFF1E9E78);
  static const successLight = Color(0xFFE0F4EC);
  static const warning = Color(0xFFC07818);
  static const warningLight = Color(0xFFFEF3E2);
  static const danger = Color(0xFFE24B4A);
  static const dangerLight = Color(0xFFFCEBEB);
  static const inactive = Color(0xFF888780);
  static const inactiveLight = Color(0xFFF1EFE8);

  // --- Light Theme ---
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryLight,
      onPrimaryContainer: primaryDark,
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: secondaryLight,
      onSecondaryContainer: secondaryDark,
      tertiary: accent,
      tertiaryContainer: accentLight,
      surface: Colors.white,
      onSurface: const Color(0xFF1A1A1A),
      error: danger,
      errorContainer: dangerLight,
    ),
    scaffoldBackgroundColor: const Color(0xFFF7F9F8),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1A1A1A),
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black.withOpacity(0.06)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF2F5F4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      labelStyle: const TextStyle(color: Color(0xFF888780)),
      prefixIconColor: primary,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: primaryLight,
      labelStyle: const TextStyle(
        color: primaryDark,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide.none,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.black.withOpacity(0.07),
      thickness: 0.5,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: Color(0xFF888780),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
  );

  // --- Dark Theme ---
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: const Color(0xFF2480CE),
      onPrimary: const Color(0xFF04312A),
      primaryContainer: const Color(0xFF084D3C),
      onPrimaryContainer: const Color(0xFFB3E4D0),
      secondary: const Color(0xFF72B5E8),
      onSecondary: const Color(0xFF042850),
      secondaryContainer: const Color(0xFF0A3F72),
      onSecondaryContainer: const Color(0xFFB0D5F3),
      surface: const Color(0xFF111E1A),
      onSurface: const Color(0xFFE8F0ED),
      error: const Color(0xFFF09595),
      errorContainer: const Color(0xFF791F1F),
    ),
    scaffoldBackgroundColor: const Color(0xFF0D1714),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF111E1A),
      foregroundColor: Color(0xFFE8F0ED),
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Color(0xFFE8F0ED),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF111E1A),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withOpacity(0.07)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2480CE),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF111E1A),
      selectedItemColor: Color(0xFF2480CE),
      unselectedItemColor: Color(0xFF888780),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
