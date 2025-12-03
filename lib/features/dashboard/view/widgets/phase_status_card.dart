import 'package:flutter/material.dart';

class PhaseStatusCard extends StatelessWidget {
  final Map<String, dynamic> phaseData;
  final VoidCallback? onTimelineTap;

  const PhaseStatusCard({
    super.key,
    required this.phaseData,
    this.onTimelineTap,
  });

  Color _parseColor(String? colorName, ThemeData theme) {
    switch (colorName?.toLowerCase()) {
      case 'green':
        return const Color(0xFF00FF94);
      case 'orange':
        return const Color(0xFFFF4500);
      case 'red':
        return const Color(0xFFFF3B30);
      case 'blue':
        return const Color(0xFF38BDF8);
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final phaseColor = _parseColor(phaseData['color'], theme);

    // Logic: Darker grey in light mode for readability
    final labelColor = theme.brightness == Brightness.light
        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
        : theme.colorScheme.secondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: phaseColor.withValues(alpha: 0.1),
        border: Border(
          left: BorderSide(color: phaseColor, width: 4),
          top: BorderSide(color: phaseColor.withValues(alpha: 0.3)),
          right: BorderSide(color: phaseColor.withValues(alpha: 0.3)),
          bottom: BorderSide(color: phaseColor.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "CURRENT PHASE",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: phaseColor,
                  letterSpacing: 1.5,
                ),
              ),
              Icon(Icons.radar, color: phaseColor, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            (phaseData['phase'] ?? 'UNKNOWN').toString().toUpperCase(),
            style: theme.textTheme.displayMedium?.copyWith(
              color: phaseColor,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            phaseData['desc'] ?? "Execute the protocol.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: phaseColor.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation(phaseColor),
          ),

          // Added Timeline Button
          if (onTimelineTap != null) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: onTimelineTap,
                icon: Icon(
                  Icons.visibility,
                  size: 16,
                  color: labelColor, // Uses high-contrast color
                ),
                label: Text(
                  "VIEW FULL TIMELINE",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: labelColor, // Uses high-contrast color
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
