import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Visibility Fix for Light Mode
    final secondaryTextColor = theme.brightness == Brightness.light
        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
        : theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
          onPressed: () => context.pop(), // Return false (no purchase)
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.diamond_outlined,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "UPGRADE TO PRO",
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Unlock the full capabilities of the system. Stop playing games. Start executing.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Features List
              Expanded(
                child: ListView(
                  children: [
                    _FeatureItem(
                      theme,
                      "AI STRATEGY GENERATION",
                      "Custom tactics based on your specific weakness.",
                      secondaryTextColor,
                    ),
                    _FeatureItem(
                      theme,
                      "DYNAMIC INJECTIONS",
                      "Notifications that adapt to your failure points.",
                      secondaryTextColor,
                    ),
                    _FeatureItem(
                      theme,
                      "UNLIMITED TIMELINE",
                      "Plan beyond 30 days. Build a legacy.",
                      secondaryTextColor,
                    ),
                    _FeatureItem(
                      theme,
                      "PANIC PROTOCOLS",
                      "Full access to state-reset tools.",
                      secondaryTextColor,
                    ),
                    _FeatureItem(
                      theme,
                      "NO ADS",
                      "Pure focus. No distractions.",
                      secondaryTextColor,
                    ),
                  ],
                ),
              ),

              // Price & CTA
              Column(
                children: [
                  Text(
                    "\$4.99 / MONTH",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Cancel anytime.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // SIMULATE PURCHASE SUCCESS
                        context.pop(true); // Return true (purchased)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 8,
                        shadowColor: theme.colorScheme.primary.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      child: Text(
                        "INITIATE UPGRADE",
                        style: GoogleFonts.jetBrainsMono(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final String subtitle;
  final Color secondaryColor;

  const _FeatureItem(
    this.theme,
    this.title,
    this.subtitle,
    this.secondaryColor,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
