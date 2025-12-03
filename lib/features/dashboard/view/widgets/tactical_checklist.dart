import 'package:flutter/material.dart';

class TacticalChecklist extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final ValueChanged<String> onToggle;
  final bool isReadOnly;

  const TacticalChecklist({
    super.key,
    required this.tasks,
    required this.onToggle,
    this.isReadOnly = false,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "DAILY PROTOCOL",
              style: theme.textTheme.labelLarge?.copyWith(
                color: labelColor,
                letterSpacing: 2.0,
              ),
            ),
            if (isReadOnly)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "HISTORY MODE",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ...tasks.map((task) {
          final isDone = task['is_completed'] == true;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: isReadOnly ? null : () => onToggle(task['id']),
              child: Opacity(
                opacity: isReadOnly ? 0.7 : 1.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom Checkbox
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: isDone
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: isDone
                              ? theme.colorScheme.primary
                              : labelColor,
                          width: 2,
                        ),
                      ),
                      child: isDone
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: theme.colorScheme.onPrimary,
                            )
                          : (isReadOnly
                                ? Icon(
                                    Icons.lock,
                                    size: 14,
                                    color: labelColor.withValues(alpha: 0.5),
                                  )
                                : null),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        task['content'] ?? "Unknown Task",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDone
                              ? labelColor
                              : theme.colorScheme.onSurface,
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: labelColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "NO ORDERS FOR THIS DAY.",
              style: theme.textTheme.bodyMedium?.copyWith(color: labelColor),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
