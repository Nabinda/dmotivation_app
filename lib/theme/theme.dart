import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ===========================================================================
  // OPTION 1: TERMINAL VELOCITY (The Engineer/Hacker Vibe)
  // Vibe: Retro-futuristic, precise, system-oriented.
  // ===========================================================================

  // DARK MODE
  static ThemeData get terminalVelocityDark {
    const primaryColor = Color(0xFF00FF94); // Phosphor Green
    const backgroundColor = Color(0xFF0A0A0A); // Almost Black
    const surfaceColor = Color(0xFF141414); // Deep Charcoal
    const errorColor = Color(0xFFFF3B30); // Safety Red

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.black,
        secondary: Color(0xFF404040),
        surface: surfaceColor,
        onSurface: Color(0xFFEDEDED),
        error: errorColor,
        tertiary: errorColor,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.jetBrainsMono(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.jetBrainsMono(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          color: const Color(0xFFEDEDED),
        ),
        bodyMedium: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          color: const Color(0xFFB0B0B0),
        ),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.jetBrainsMono(
          color: primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Color(0xFF333333), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          textStyle: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // LIGHT MODE
  static ThemeData get terminalVelocityLight {
    const primaryColor = Color(
      0xFF00C853,
    ); // Darker Green for visibility on white
    const backgroundColor = Color(0xFFF5F5F5); // White Smoke
    const surfaceColor = Color(0xFFFFFFFF); // Pure White
    const errorColor = Color(0xFFD32F2F); // Darker Red

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: Color(0xFFE0E0E0),
        surface: surfaceColor,
        onSurface: Color(0xFF212121),
        error: errorColor,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.jetBrainsMono(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
          color: Colors.black,
        ),
        displayMedium: GoogleFonts.jetBrainsMono(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          color: const Color(0xFF212121),
        ),
        bodyMedium: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          color: const Color(0xFF616161),
        ),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.jetBrainsMono(
          color: primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          textStyle: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ===========================================================================
  // OPTION 2: DEFCON 1 (The Aggressive/Urgency Vibe)
  // Vibe: Warning signs, cockpit alerts, high stakes.
  // ===========================================================================

  // DARK MODE
  static ThemeData get defcon1Dark {
    const primaryColor = Color(0xFFFF4500); // International Orange
    const backgroundColor = Color(0xFF050505); // True Black
    const surfaceColor = Color(0xFF111111); // Carbon

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: Color(0xFF555555),
        surface: surfaceColor,
        onSurface: Colors.white,
        error: primaryColor,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.oswald(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.oswald(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.robotoMono(fontSize: 16, color: Colors.white),
        bodyMedium: GoogleFonts.robotoMono(
          fontSize: 14,
          color: const Color(0xFF888888),
        ),
        labelLarge: GoogleFonts.oswald(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        centerTitle: true,
        titleTextStyle: GoogleFonts.oswald(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: const BorderSide(color: Color(0xFF222222), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return primaryColor;
          return Colors.transparent;
        }),
        side: const BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  // LIGHT MODE
  static ThemeData get defcon1Light {
    const primaryColor = Color(
      0xFFFF4500,
    ); // International Orange (Kept same for urgency)
    const backgroundColor = Color(0xFFFFFFFF); // Pure White
    const surfaceColor = Color(0xFFF5F5F5); // Light Grey

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: Color(0xFFBDBDBD),
        surface: surfaceColor,
        onSurface: Colors.black,
        error: primaryColor,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.oswald(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: Colors.black,
        ),
        displayMedium: GoogleFonts.oswald(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.robotoMono(fontSize: 16, color: Colors.black),
        bodyMedium: GoogleFonts.robotoMono(
          fontSize: 14,
          color: const Color(0xFF424242),
        ),
        labelLarge: GoogleFonts.oswald(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        centerTitle: true,
        titleTextStyle: GoogleFonts.oswald(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return primaryColor;
          return Colors.transparent;
        }),
        side: const BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  // ===========================================================================
  // OPTION 3: COLD TRUTH (The Clinical Vibe)
  // Vibe: Surgical, cold, unemotional, high-tech.
  // ===========================================================================

  // DARK MODE
  static ThemeData get coldTruthDark {
    const primaryColor = Color(0xFF38BDF8); // Ice Blue
    const backgroundColor = Color(0xFF0F172A); // Dark Slate Blue
    const surfaceColor = Color(0xFF1E293B); // Dark Slate

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: backgroundColor,
        secondary: Color(0xFF334155),
        surface: surfaceColor,
        onSurface: Color(0xFFF1F5F9),
        tertiary: Color(0xFF94A3B8),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.spaceMono(
          fontSize: 16,
          color: const Color(0xFFE2E8F0),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF94A3B8),
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
      ),
    );
  }

  // LIGHT MODE
  static ThemeData get coldTruthLight {
    const primaryColor = Color(
      0xFF0284C7,
    ); // Sky 600 (Darker Blue for light mode)
    const backgroundColor = Color(0xFFF1F5F9); // Slate 100
    const surfaceColor = Color(0xFFFFFFFF); // White

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: Color(0xFFCBD5E1), // Slate 300
        surface: surfaceColor,
        onSurface: Color(0xFF0F172A), // Slate 900
        tertiary: Color(0xFF64748B), // Slate 500
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: Color(0xFF0F172A),
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.spaceMono(
          fontSize: 16,
          color: const Color(0xFF334155),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF64748B),
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: Color(0xFF0F172A),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Color(0xFFE2E8F0),
          ), // Light Slate border
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
