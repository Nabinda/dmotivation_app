import 'package:flutter/material.dart';
import '../../../components/time_selector.dart';
import '../../../components/selection_chip.dart';

class ScheduleStep extends StatelessWidget {
  final TimeOfDay wakeTime;
  final TimeOfDay sleepTime;
  final List<String> selectedPreferences; // Added state
  final ValueChanged<String> onTogglePreference; // Added callback
  final VoidCallback onWakeTimeTap;
  final VoidCallback onSleepTimeTap;

  const ScheduleStep({
    super.key,
    required this.wakeTime,
    required this.sleepTime,
    required this.selectedPreferences,
    required this.onTogglePreference,
    required this.onWakeTimeTap,
    required this.onSleepTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // The available options for injections
    final options = ["Morning Kickoff", "Mid-Day Check", "Evening Review"];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "STEP 03 / 04",
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text("BATTLE RHYTHM", style: theme.textTheme.displayMedium),
          const SizedBox(height: 16),
          Text(
            "Define your operational window. We inject motivation when you are awake.",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: TimeSelector(
                  label: "WAKE UP",
                  time: wakeTime,
                  onTap: onWakeTimeTap,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TimeSelector(
                  label: "SLEEP",
                  time: sleepTime,
                  onTap: onSleepTimeTap,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          Text("INJECTION PREFERENCES", style: theme.textTheme.labelLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selectedPreferences.contains(option);
              return SelectionChip(
                label: option,
                isSelected: isSelected,
                onTap: () => onTogglePreference(option),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
