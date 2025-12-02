import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator; // Added validation function

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          // Changed from TextField to TextFormField
          maxLines: maxLines,
          style: theme.textTheme.bodyLarge,
          onChanged: onChanged,
          validator: validator, // Hook up validator
          autovalidateMode:
              AutovalidateMode.onUserInteraction, // Validate on interaction
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.secondary),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            // Added Error Border Styles
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.error),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            filled: true,
            fillColor: theme.cardTheme.color,
          ),
        ),
      ],
    );
  }
}
