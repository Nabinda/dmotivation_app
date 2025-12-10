import 'package:flutter/material.dart';

class StrategyDayEditor extends StatelessWidget {
  final Map<String, dynamic> dayData;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onDelete;

  const StrategyDayEditor({
    super.key,
    required this.dayData,
    required this.onToggle,
    required this.onAdd,
    required this.onDelete,
  });

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ADD TASK"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter task details"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onAdd(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text("ADD"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tasks = List<Map<String, dynamic>>.from(dayData['tasks']);
    final dayLabel = "DAY ${dayData['day'].toString().padLeft(2, '0')}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: () => _showAddDialog(context),
                tooltip: "Add Task",
              ),
            ],
          ),
          const Divider(),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "No tasks.",
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
            ),
          ...tasks.map((task) {
            final isDone = task['is_completed'] == true;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Checkbox(
                value: isDone,
                onChanged: (_) => onToggle(task['id']),
                activeColor: theme.colorScheme.secondary,
              ),
              title: Text(
                task['content'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDone
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.onSurface,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 16,
                  color: theme.colorScheme.error.withValues(alpha: 0.5),
                ),
                onPressed: () => onDelete(task['id']),
              ),
            );
          }),
        ],
      ),
    );
  }
}
