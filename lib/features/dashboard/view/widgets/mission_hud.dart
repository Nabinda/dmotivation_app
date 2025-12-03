import 'package:flutter/material.dart';

class MissionHUD extends StatelessWidget {
  final String missionTitle;
  final int daysRemaining;
  final int dayIndex;
  final VoidCallback? onDateTap; // Added Date Picker Callback

  const MissionHUD({
    super.key,
    required this.missionTitle,
    required this.daysRemaining,
    required this.dayIndex,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final labelColor = theme.brightness == Brightness.light
        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
        : theme.colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MISSION OBJECTIVE",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 4),
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
            ),

            // Day Indicator (Clickable for Calendar)
            InkWell(
              onTap: onDateTap,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: labelColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: theme.colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "DAY ${dayIndex.toString().padLeft(2, '0')}",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
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
