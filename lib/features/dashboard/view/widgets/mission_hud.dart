import 'package:flutter/material.dart';

class MissionHUD extends StatelessWidget {
  final String missionTitle;
  final int daysRemaining;
  final int dayIndex;

  const MissionHUD({
    super.key,
    required this.missionTitle,
    required this.daysRemaining,
    required this.dayIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Logic: If in Light Mode, 'secondary' (grey) is too light against white.
    // We use onSurface (Black) with 60% opacity for better contrast.
    // In Dark Mode, 'secondary' is readable against black.
    final labelColor = theme.brightness == Brightness.light
        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
        : theme.colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MISSION OBJECTIVE",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: labelColor,
                  ),
                ),
                Text(
                  missionTitle.toUpperCase(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: labelColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "DAY ${dayIndex.toString().padLeft(2, '0')}",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              daysRemaining.toString(),
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 64,
                height: 1.0,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                "DAYS\nREMAINING",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: labelColor,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 48),
      ],
    );
  }
}
