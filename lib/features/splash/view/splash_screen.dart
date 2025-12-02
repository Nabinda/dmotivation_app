import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<String> _logs = [];
  final List<String> _bootSequence = [
    "INITIALIZING KERNEL...",
    "MOUNTING HIVE_DB...",
    "LOADING USER_PROFILE...",
    "CHECKING SUBSCRIPTION_STATUS...",
    "ESTABLISHING SECURE CONNECTION...",
    "SYSTEM READY.",
    "WELCOME TO THE WAR ROOM.",
  ];

  @override
  void initState() {
    super.initState();
    _runBootSequence();
  }

  void _runBootSequence() async {
    for (final line in _bootSequence) {
      await Future.delayed(Duration(milliseconds: 300 + (line.length * 5)));
      if (mounted) {
        setState(() {
          _logs.add(line);
        });
      }
    }

    // Wait a moment after final log, then navigate
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      context.go('/home'); // Navigate to the main dashboard/showcase
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access dynamic theme data
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    // Use bodyMedium color for inactive logs to ensure good contrast in both light/dark modes
    final dimColor = theme.textTheme.bodyMedium?.color ?? colorScheme.secondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dynamic background
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Logo Image
            Image.asset('assets/logo/logo_512.png', height: 100, width: 100),
            const SizedBox(height: 24),

            // The Logo / Title
            Text(
              "D/MOTIVATION",
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                // Color comes from theme.textTheme.displayLarge automatically
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: 100,
              color: primaryColor, // Dynamic accent color
            ),
            const Spacer(),

            // The Boot Logs
            ..._logs.map(
              (log) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "> $log",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    // Use primary color for the "System Ready" success state
                    color: log == "SYSTEM READY." ? primaryColor : dimColor,
                    fontSize: 12,
                    // Ensure we use a monospace look if the theme allows,
                    // mostly inherited from bodyMedium in AppTheme.
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Blinking Cursor
            const SizedBox(height: 4),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value > 0.5 ? 1.0 : 0.0,
                  child: Container(
                    width: 8,
                    height: 14,
                    color: primaryColor, // Dynamic cursor color
                  ),
                );
              },
              onEnd:
                  () {}, // Loop handled by repeating logic if needed, or simple blink
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
