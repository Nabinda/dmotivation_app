import 'package:flutter/material.dart';
import 'widgets/action_timer.dart';
import 'widgets/box_breathing.dart';

class PanicSheet extends StatelessWidget {
  const PanicSheet({super.key});

  void _triggerIntervention(BuildContext context, String state) {
    Navigator.pop(context); // Close the selection sheet

    // Determine the correct tool based on state
    Widget tool;
    String title;

    switch (state) {
      case 'LAZY':
      case 'PROCRASTINATING':
        title = "FORCE ACTION";
        tool = const ActionTimer();
        break;
      case 'ANXIOUS':
      case 'BURNOUT':
      case 'LOST':
        title = "SYSTEM RESET";
        tool = const BoxBreathing();
        break;
      default:
        title = "INTERVENTION";
        tool = const ActionTimer();
    }

    final theme = Theme.of(context);

    // Show Full Screen Intervention
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      // FIXED: Use theme background color instead of hardcoded black
      // We use a slightly transparent version if we want to see behind,
      // but for Panic Mode, opaque (alpha 1.0) is usually best to isolate.
      barrierColor: theme.scaffoldBackgroundColor,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          // FIXED: Use theme background
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              // FIXED: Use onSurface for visibility in Light/Dark modes
              icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: tool,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final states = ['LAZY', 'ANXIOUS', 'BURNOUT', 'PROCRASTINATING', 'LOST'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          top: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
              const SizedBox(width: 12),
              Text(
                "REPORT STATUS",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.error,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Identify the blockage. We will deploy the counter-measure.",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Grid of States
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: states
                .map(
                  (state) => _PanicButton(
                    label: state,
                    onTap: () => _triggerIntervention(context, state),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _PanicButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PanicButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.error.withValues(alpha: 0.5),
          ),
          color: theme.colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
