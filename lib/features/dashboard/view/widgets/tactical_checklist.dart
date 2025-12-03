import 'package:flutter/material.dart';

class TacticalChecklist extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final ValueChanged<String> onToggle;

  const TacticalChecklist({
    super.key,
    required this.tasks,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Visibility Logic
    final labelColor = theme.brightness == Brightness.light
        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
        : theme.colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "DAILY PROTOCOL",
          style: theme.textTheme.labelLarge?.copyWith(
            color: labelColor, // Better visibility than secondary
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 16),
        ...tasks.map((task) {
          final isDone = task['is_completed'] == true;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () => onToggle(task['id']),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: isDone
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: isDone ? theme.colorScheme.primary : labelColor,
                        width: 2,
                      ),
                    ),
                    child: isDone
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      task['content'] ?? "Unknown Task",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        // Use labelColor for done items (dimmed but readable)
                        // Use onSurface for active items (fully visible)
                        color: isDone
                            ? labelColor
                            : theme.colorScheme.onSurface,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        decorationColor: labelColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "NO ORDERS FOR TODAY.\nREST AND RECOVER.",
              style: theme.textTheme.bodyMedium?.copyWith(color: labelColor),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
