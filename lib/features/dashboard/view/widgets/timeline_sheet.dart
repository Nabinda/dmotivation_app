import 'package:flutter/material.dart';

class TimelineSheet extends StatelessWidget {
  final List<dynamic> milestones;
  final int currentDay;

  const TimelineSheet({
    super.key,
    required this.milestones,
    required this.currentDay,
  });

  Color _parseColor(String? colorName, ThemeData theme) {
    switch (colorName?.toLowerCase()) {
      case 'green':
        return const Color(0xFF00FF94);
      case 'orange':
        return const Color(0xFFFF4500);
      case 'red':
        return const Color(0xFFFF3B30);
      case 'blue':
        return const Color(0xFF38BDF8);
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Visibility Logic
    final labelColor = theme.brightness == Brightness.light
        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
        : theme.colorScheme.secondary;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: labelColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "OPERATIONAL TIMELINE",
            style: theme.textTheme.titleLarge?.copyWith(
              letterSpacing: 1.5,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "CURRENT DAY: $currentDay",
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: milestones.length,
              itemBuilder: (context, index) {
                final milestone = milestones[index];
                final dayOffset = milestone['day_offset'] as int;
                final color = _parseColor(milestone['color'], theme);

                // Determine State
                final isPast = currentDay > dayOffset;
                final isActive =
                    !isPast &&
                    (index == 0 ||
                        currentDay >
                            (milestones[index - 1]['day_offset'] as int));

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Timeline Line & Dot
                      Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isActive || isPast
                                  ? color
                                  : Colors.transparent,
                              border: Border.all(color: color, width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: isActive
                                ? Center(
                                    child: Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.onSurface,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          Expanded(
                            child: index < milestones.length - 1
                                ? Container(
                                    width: 2,
                                    color: isPast
                                        ? color
                                        : labelColor.withValues(alpha: 0.2),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),

                      // Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "PHASE ${index + 1}",
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: isActive ? color : labelColor,
                                    ),
                                  ),
                                  Text(
                                    "DAY $dayOffset",
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: labelColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (milestone['phase'] ?? '')
                                    .toString()
                                    .toUpperCase(),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: isActive || isPast
                                      ? theme.colorScheme.onSurface
                                      : labelColor,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                milestone['desc'] ?? '',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isActive
                                      ? theme.colorScheme.onSurface
                                      : labelColor.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
