import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PanicLogsScreen extends StatelessWidget {
  const PanicLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    // Visibility Fix for Light Mode
    final secondaryTextColor = theme.brightness == Brightness.light
        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
        : theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "PANIC LOGS",
          style: theme.textTheme.titleMedium?.copyWith(
            letterSpacing: 2.0,
            color: onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _PanicLogItem(
            theme: theme,
            trigger: "LAZY",
            tool: "Action Timer",
            time: "TODAY, 14:00",
            status: "RESOLVED",
            secondaryColor: secondaryTextColor,
          ),
          _PanicLogItem(
            theme: theme,
            trigger: "ANXIOUS",
            tool: "Box Breathing",
            time: "YESTERDAY, 09:30",
            status: "ABORTED",
            secondaryColor: secondaryTextColor,
          ),
          _PanicLogItem(
            theme: theme,
            trigger: "BURNOUT",
            tool: "System Reset",
            time: "NOV 21, 20:00",
            status: "RESOLVED",
            secondaryColor: secondaryTextColor,
          ),
        ],
      ),
    );
  }
}

class _PanicLogItem extends StatelessWidget {
  final ThemeData theme;
  final String trigger;
  final String tool;
  final String time;
  final String status;
  final Color secondaryColor;

  const _PanicLogItem({
    required this.theme,
    required this.trigger,
    required this.tool,
    required this.time,
    required this.status,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = status == "RESOLVED";
    final color = isResolved
        ? theme.colorScheme.primary
        : theme.colorScheme.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 2)),
        color: theme.cardTheme.color,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "[$trigger]",
                      style: GoogleFonts.jetBrainsMono(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tool.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: secondaryColor, // Using fixed color
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              status,
              style: GoogleFonts.jetBrainsMono(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
