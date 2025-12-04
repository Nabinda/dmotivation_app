import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TacticalAnalyticsScreen extends StatelessWidget {
  const TacticalAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

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
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "TACTICAL ANALYTICS",
          style: theme.textTheme.titleMedium?.copyWith(
            letterSpacing: 2.0,
            color: onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATS GRID
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    theme,
                    "CURRENT STREAK",
                    "5",
                    "DAYS",
                    true,
                    secondaryTextColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    theme,
                    "COMPLETION",
                    "87",
                    "%",
                    false,
                    secondaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _StatCard(
              theme,
              "TOTAL MISSIONS",
              "1",
              "ACTIVE",
              false,
              secondaryTextColor,
            ),

            const SizedBox(height: 48),

            // WEEKLY GRAPH
            Text(
              "WEEKLY OUTPUT",
              style: theme.textTheme.labelSmall?.copyWith(
                color: secondaryTextColor,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 240,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(4),
                color: theme.cardTheme.color?.withValues(alpha: 0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _Bar(theme, 0.4, "M", false, secondaryTextColor),
                  _Bar(theme, 0.8, "T", true, secondaryTextColor),
                  _Bar(theme, 1.0, "W", true, secondaryTextColor),
                  _Bar(theme, 0.2, "T", false, secondaryTextColor),
                  _Bar(theme, 0.9, "F", true, secondaryTextColor),
                  _Bar(theme, 0.5, "S", true, secondaryTextColor),
                  _Bar(theme, 0.0, "S", false, secondaryTextColor),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // INSIGHTS
            Text(
              "INTELLIGENCE REPORT",
              style: theme.textTheme.labelSmall?.copyWith(
                color: secondaryTextColor,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: primary, width: 4)),
                color: primary.withValues(alpha: 0.1),
              ),
              child: Text(
                "You consistently fail on Sundays. Recommend scheduling 'Low Intensity' protocol for weekends to maintain momentum.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: onSurface,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final ThemeData theme;
  final String label;
  final String value;
  final String unit;
  final bool isHighlight;
  final Color secondaryColor;

  const _StatCard(
    this.theme,
    this.label,
    this.value,
    this.unit,
    this.isHighlight,
    this.secondaryColor,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        border: Border.all(
          color: isHighlight
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: secondaryColor,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: theme.textTheme.displayMedium?.copyWith(
                  color: isHighlight
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final ThemeData theme;
  final double heightPct;
  final String label;
  final bool isComplete;
  final Color labelColor;

  const _Bar(
    this.theme,
    this.heightPct,
    this.label,
    this.isComplete,
    this.labelColor,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (heightPct > 0)
          Container(
            width: 12,
            height: 150 * heightPct,
            decoration: BoxDecoration(
              color: isComplete
                  ? theme.colorScheme.primary
                  : theme.colorScheme.secondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        const SizedBox(height: 12),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
