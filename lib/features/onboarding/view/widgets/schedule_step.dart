import 'package:flutter/material.dart';
import '../../../components/time_selector.dart';
import '../../../components/selection_chip.dart';

class ScheduleStep extends StatelessWidget {
  final TimeOfDay wakeTime;
  final TimeOfDay sleepTime;
  final List<String> selectedPreferences;
  final ValueChanged<String> onTogglePreference;
  final VoidCallback onWakeTimeTap;
  final VoidCallback onSleepTimeTap;
  final String reviewFrequency;
  final ValueChanged<String> onFrequencyChanged;

  const ScheduleStep({
    super.key,
    required this.wakeTime,
    required this.sleepTime,
    required this.selectedPreferences,
    required this.onTogglePreference,
    required this.onWakeTimeTap,
    required this.onSleepTimeTap,
    required this.reviewFrequency,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            "Define your operational window and review cadence.",
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
          Text("DEBRIEF CADENCE", style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(
            "How often should the AI break down your tasks?",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FrequencyOption(
                  label: "DAILY",
                  subLabel: "Micro-Management",
                  isSelected: reviewFrequency == 'Daily',
                  theme: theme,
                  onTap: () => onFrequencyChanged('Daily'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FrequencyOption(
                  label: "WEEKLY",
                  subLabel: "Big Picture",
                  isSelected: reviewFrequency == 'Weekly',
                  theme: theme,
                  onTap: () => onFrequencyChanged('Weekly'),
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

class _FrequencyOption extends StatelessWidget {
  final String label;
  final String subLabel;
  final bool isSelected;
  final ThemeData theme;
  final VoidCallback onTap;

  const _FrequencyOption({
    required this.label,
    required this.subLabel,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subLabel,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
