import 'package:flutter/material.dart';

class EnemyStep extends StatelessWidget {
  final List<String> selectedWeaknesses;
  final ValueChanged<String> onToggleWeakness;

  const EnemyStep({
    super.key,
    required this.selectedWeaknesses,
    required this.onToggleWeakness,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enemies = [
      "Procrastination",
      "Fear of Failure",
      "Distraction",
      "Burnout",
      "Perfectionism",
      "Fatigue",
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "STEP 04 / 04",
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text("KNOW THE ENEMY", style: theme.textTheme.displayMedium),
          const SizedBox(height: 16),
          Text(
            "What usually stops you? We will target these specific weaknesses.",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: enemies.map((enemy) {
              final isSelected = selectedWeaknesses.contains(enemy);
              return InkWell(
                onTap: () => onToggleWeakness(enemy),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    // Updated: Use withValues instead of withOpacity
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.2)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        Icon(
                          Icons.warning,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        enemy.toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
