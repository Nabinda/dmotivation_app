import 'package:flutter/material.dart';

Color parseColor(String? colorName, ThemeData theme) {
  final isLight = theme.brightness == Brightness.light;

  switch (colorName?.toLowerCase()) {
    case 'green':
      return isLight ? const Color(0xFF008945) : const Color(0xFF00FF94);
    case 'orange':
      return isLight ? const Color(0xFFD84315) : const Color(0xFFFF4500);
    case 'red':
      return isLight ? const Color(0xFFD32F2F) : const Color(0xFFFF3B30);
    case 'blue':
      return isLight ? const Color(0xFF0277BD) : const Color(0xFF38BDF8);
    default:
      return theme.colorScheme.primary;
  }
}
