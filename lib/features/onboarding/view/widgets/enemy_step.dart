import 'package:flutter/material.dart';
import '../../../components/app_text_field.dart';

class EnemyStep extends StatefulWidget {
  final List<String> selectedWeaknesses;
  final ValueChanged<String> onToggleWeakness;

  const EnemyStep({
    super.key,
    required this.selectedWeaknesses,
    required this.onToggleWeakness,
  });

  @override
  State<EnemyStep> createState() => _EnemyStepState();
}

class _EnemyStepState extends State<EnemyStep> {
  final TextEditingController _customEnemyController = TextEditingController();

  // Default preset enemies
  final List<String> _defaultEnemies = [
    "Procrastination",
    "Fear of Failure",
    "Distraction",
    "Burnout",
    "Perfectionism",
    "Fatigue",
  ];

  @override
  void dispose() {
    _customEnemyController.dispose();
    super.dispose();
  }

  void _addCustomEnemy() {
    final text = _customEnemyController.text.trim();
    if (text.isNotEmpty) {
      // Add to selection if not already there
      if (!widget.selectedWeaknesses.contains(text)) {
        widget.onToggleWeakness(text);
      }
      FocusScope.of(context).unfocus();
      _customEnemyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Combine defaults with any custom ones the user has selected so they appear as chips
    // We use a Set to avoid duplicates if a custom one matches a default one
    final allDisplayEnemies = {
      ..._defaultEnemies,
      ...widget.selectedWeaknesses,
    }.toList();

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
            "What usually stops you? Select from the list or identify your own.",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // 1. The Chip Cloud
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: allDisplayEnemies.map((enemy) {
              final isSelected = widget.selectedWeaknesses.contains(enemy);
              return InkWell(
                onTap: () => widget.onToggleWeakness(enemy),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
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

          const SizedBox(height: 32),

          // 2. Custom Input Area
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AppTextField(
                  controller: _customEnemyController,
                  label: "NEW ENEMY",
                  hint: "e.g. Social Media, Sugar",
                  onChanged: (val) {}, // Handled by controller
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 56, // Matches default height of TextFormField
                width: 56,
                margin: const EdgeInsets.only(
                  bottom: 0,
                ), // Align with text field
                child: IconButton.filled(
                  onPressed: _addCustomEnemy,
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
