import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionHelper {
  /// Checks if notification permission is currently granted.
  static Future<bool> isGranted() async {
    return await Permission.notification.isGranted;
  }

  /// Requests notification permission.
  ///
  /// Returns `true` if granted.
  /// Returns `false` if denied.
  /// Triggers [onPermanentlyDenied] callback if the user has permanently denied permission
  /// (usually prompts to open settings).
  static Future<bool> requestPermission({
    required VoidCallback onPermanentlyDenied,
  }) async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.notification.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      onPermanentlyDenied();
      return false;
    }

    return false;
  }

  /// Shows a standard dialog prompting the user to open system settings.
  static void showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("PERMISSION REQUIRED"),
        content: const Text(
          "Notifications are permanently disabled. Please enable them in system settings to receive updates.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text("OPEN SETTINGS"),
          ),
        ],
      ),
    );
  }
}
