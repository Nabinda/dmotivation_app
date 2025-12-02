import 'package:flutter/material.dart';
import '../../../components/app_text_field.dart';
import '../../../components/option_card.dart';

class ProtocolStep extends StatelessWidget {
  final String intensity;
  final ValueChanged<String> onIntensityChanged;

  const ProtocolStep({
    super.key,
    required this.intensity,
    required this.onIntensityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "STEP 02 / 04",
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text("SET INTENSITY", style: theme.textTheme.displayMedium),
          const SizedBox(height: 16),
          Text(
            "Choose your operating cadence. Strategy requires sacrifice.",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          OptionCard(
            title: "MODERATE",
            desc: "Steady progress. Work/Life balance maintained.",
            isSelected: intensity == 'Moderate',
            onTap: () => onIntensityChanged('Moderate'),
          ),
          const SizedBox(height: 12),
          OptionCard(
            title: "HIGH",
            desc: "Aggressive growth. Prioritized above leisure.",
            isSelected: intensity == 'High',
            onTap: () => onIntensityChanged('High'),
          ),
          const SizedBox(height: 12),
          OptionCard(
            title: "EXTREME",
            desc: "Obsession. All-in. Nothing else matters.",
            isSelected: intensity == 'Extreme',
            onTap: () => onIntensityChanged('Extreme'),
          ),

          const SizedBox(height: 32),
          AppTextField(
            label: "DAILY PROTOCOL",
            hint: "One non-negotiable task (e.g. 2 hrs Deep Work)",
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}
