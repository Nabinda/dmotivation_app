import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ===========================================================================
  // ARISE: SOLO LEVELING VIBE (Shadow Monarch & System Aesthetic)
  // ===========================================================================

  // DARK MODE (The Monarchy / Shadow Dungeon Vibe)
  static ThemeData get ariseDark {
    const primaryColor = Color(0xFF9D4EDD); // Monarch Purple
    const secondaryColor = Color(0xFF00F5D4); // Mana Cyan Glow
    const backgroundColor = Color(0xFF07050B); // Absolute Void Black
    const surfaceColor = Color(0xFF13101B); // Deep Slate Panel
    const errorColor = Color(0xFFFF3366); // Critical Alert Red

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        surface: surfaceColor,
        onSurface: Color(0xFFE2E8F0),
        error: errorColor,
        tertiary: secondaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        hintStyle: GoogleFonts.rajdhani(
          color: const Color(0xFF64748B),
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2A2438), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.rajdhani(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFE2E8F0),
        ),
        bodyMedium: GoogleFonts.rajdhani(
          fontSize: 16,
          color: const Color(0xFF94A3B8),
        ),
        labelLarge: GoogleFonts.orbitron(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: secondaryColor),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF2A2438), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: GoogleFonts.orbitron(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.black,
      ),
    );
  }

  // LIGHT MODE (The Hunter Association / Awakened Plaza Vibe)
  static ThemeData get ariseLight {
    const primaryColor = Color(0xFF7B2CBF); // Deep Royal Purple
    const secondaryColor = Color(0xFF0077B6); // Clean Mana Blue
    const backgroundColor = Color(0xFFF8FAFC); // Clean System White-Blue
    const surfaceColor = Color(0xFFFFFFFF); // Pure White Cards
    const errorColor = Color(0xFFD90429); // Alert Red

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        surface: surfaceColor,
        onSurface: Color(0xFF0F172A),
        error: errorColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        hintStyle: GoogleFonts.rajdhani(
          color: const Color(0xFF94A3B8),
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Color(0xFF0F172A),
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.rajdhani(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
        bodyMedium: GoogleFonts.rajdhani(
          fontSize: 16,
          color: const Color(0xFF475569),
        ),
        labelLarge: GoogleFonts.orbitron(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: GoogleFonts.orbitron(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
