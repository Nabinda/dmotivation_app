import 'package:flutter/material.dart';
import '../../../components/app_text_field.dart';

class MissionStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onObjectiveChanged;
  final DateTime? deadline;
  final VoidCallback onDeadlineTap;

  const MissionStep({
    super.key,
    required this.formKey,
    required this.onObjectiveChanged,
    required this.deadline,
    required this.onDeadlineTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("STEP 01 / 04", style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
            const SizedBox(height: 8),
            Text("DEFINE THE MISSION", style: theme.textTheme.displayMedium),
            const SizedBox(height: 16),
            Text(
              "What is the single objective you are hunting? Be specific.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            
            AppTextField(
              label: "TARGET OBJECTIVE",
              hint: "e.g., Launch MVP, Lose 10kg",
              onChanged: onObjectiveChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Objective cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: "THE DEEP WHY",
              hint: "Why does this matter? What is the pain of failure?",
              maxLines: 3,
              onChanged: (val) {},
            ),
            const SizedBox(height: 24),
            Text("DEADLINE", style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            InkWell(
              onTap: onDeadlineTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: deadline == null ? theme.colorScheme.secondary : theme.colorScheme.primary
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today, 
                      color: deadline == null ? theme.colorScheme.secondary : theme.colorScheme.primary
                    ),
                    const SizedBox(width: 16),
                    Text(
                      deadline == null 
                        ? "SELECT DATE" 
                        : "${deadline!.day}/${deadline!.month}/${deadline!.year}",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: deadline == null ? theme.colorScheme.secondary : theme.colorScheme.onSurface
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}