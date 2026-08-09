// THEME LOCK: dark — source: domain signal (developer/utility tool, used at night/desk)
// Scaffold.backgroundColor = AppTheme.backgroundDark — ALL screens

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryContainer = Color(0xFF4A3FB5);
  static const Color secondary = Color(0xFF00B894);
  static const Color secondaryContainer = Color(0xFF00956F);
  static const Color accent = Color(0xFFFD79A8);

  // Semantic colors
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFE17055);

  // Dark surfaces
  static const Color surfaceDark = Color(0xFF1E1B2E);
  static const Color surfaceVariantDark = Color(0xFF2A2640);
  static const Color backgroundDark = Color(0xFF13111F);
  static const Color cardDark = Color(0xFF252136);

  // Light surfaces
  static const Color surfaceLight = Color(0xFFF8F7FF);
  static const Color backgroundLight = Color(0xFFF0EEF9);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE8E4FF),
      onPrimaryContainer: Color(0xFF1A0066),
      secondary: secondary,
      onSecondary: Colors.white,
      surface: surfaceLight,
      onSurface: Color(0xFF1A1A2E),
      error: error,
      onError: Colors.white,
      outline: Color(0xFFCCCAD8),
      outlineVariant: Color(0xFFE8E6F0),
    ),
    scaffoldBackgroundColor: backgroundLight,
    textTheme: GoogleFonts.outfitTextTheme().apply(
      bodyColor: Color(0xFF1A1A2E),
      displayColor: Color(0xFF1A1A2E),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFFE8E4FF),
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: Color(0xFFE0FFF8),
      surface: surfaceDark,
      onSurface: Color(0xFFEAE8F5),
      error: error,
      onError: Colors.white,
      outline: Color(0xFF4A4660),
      outlineVariant: Color(0xFF312D4A),
    ),
    scaffoldBackgroundColor: backgroundDark,
    textTheme: GoogleFonts.outfitTextTheme().apply(
      bodyColor: Color(0xFFEAE8F5),
      displayColor: Color(0xFFEAE8F5),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFFEAE8F5),
      ),
      iconTheme: IconThemeData(color: Color(0xFFEAE8F5)),
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: surfaceVariantDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF4A4660)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF4A4660)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      labelStyle: TextStyle(color: Color(0xFF9A96B8)),
      hintStyle: TextStyle(color: Color(0xFF6B6888)),
    ),
  );
}
