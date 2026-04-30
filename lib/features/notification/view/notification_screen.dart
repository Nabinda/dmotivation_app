import 'package:dmotivation/core/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/notification_permission_helper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  // Local State
  bool _isMasterEnabled = false; // Default off until checked
  TimeOfDay _wakeTime = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _sleepTime = const TimeOfDay(hour: 22, minute: 30);

  // Injection Type Toggles
  bool _morningBrief = true;
  bool _randomInjections = true;
  bool _eveningDebrief = false;

  @override
  void initState() {
    super.initState();
    // Listen to app lifecycle to detect when user returns from Settings
    WidgetsBinding.instance.addObserver(this);
    _checkSystemPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkSystemPermission();
    }
  }

  /// Syncs local switch state with actual system permission status.
  Future<void> _checkSystemPermission() async {
    final isGranted = await NotificationPermissionHelper.isGranted();
    if (mounted) {
      setState(() {
        _isMasterEnabled = isGranted;
      });
    }
  }

  /// Handles the toggle logic including permission requests using the helper
  Future<void> _toggleMasterSwitch(bool value) async {
    if (value) {
      // User wants to ENABLE
      final granted = await NotificationPermissionHelper.requestPermission(
        onPermanentlyDenied: () {
          if (mounted) NotificationPermissionHelper.showSettingsDialog(context);
        },
      );

      if (mounted) {
        setState(() => _isMasterEnabled = granted);
      }
    } else {
      // User wants to DISABLE (Logically mute app)
      setState(() => _isMasterEnabled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Helper for "Terminal" vibe text style
    TextStyle headerStyle = theme.textTheme.labelLarge!.copyWith(
      color: theme.colorScheme.primary,
      letterSpacing: 1.5,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "NOTIFICATIONS",
          style: theme.textTheme.titleMedium?.copyWith(
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // 1. MASTER SWITCH
          _buildMasterSwitch(theme),

          const SizedBox(height: 32),

          // 2. ACTIVE HOURS
          Text("ACTIVE HOURS", style: headerStyle),
          const SizedBox(height: 16),
          _buildTimeCard(
            context,
            title: "WAKE TIME",
            time: _wakeTime,
            icon: Icons.wb_sunny_outlined,
            onTap: () => _pickTime(context, isWake: true),
          ),
          const SizedBox(height: 12),
          _buildTimeCard(
            context,
            title: "SLEEP TIME",
            time: _sleepTime,
            icon: Icons.nightlight_outlined,
            onTap: () => _pickTime(context, isWake: false),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4),
            child: Text(
              "Notifications will be sent during these hours.",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // 3. CONFIGURATION
          Text("NOTIFICATION TYPES", style: headerStyle),
          const SizedBox(height: 16),
          _buildToggleTile(
            theme,
            title: "MORNING BRIEF",
            subtitle: "Daily summary at wake time.",
            value: _morningBrief,
            onChanged: (v) => setState(() => _morningBrief = v),
          ),
          _buildToggleTile(
            theme,
            title: "RANDOM REMINDERS",
            subtitle: "Occasional reminders throughout the day.",
            value: _randomInjections,
            onChanged: (v) => setState(() => _randomInjections = v),
          ),
          _buildToggleTile(
            theme,
            title: "EVENING REVIEW",
            subtitle: "Daily review before sleep.",
            value: _eveningDebrief,
            onChanged: (v) => setState(() => _eveningDebrief = v),
          ),

          const SizedBox(height: 48),

          // 4. TEST BUTTON
          Center(
            child: OutlinedButton.icon(
              onPressed: _isMasterEnabled
                  ? () async {
                      // 1. Trigger the 30-second timer
                      await NotificationService().scheduleTestNotification();

                      // 2. Show the confirmation SnackBar
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Test scheduled. Lock your phone and wait 30 seconds.",
                            style: GoogleFonts.jetBrainsMono(),
                          ),
                          backgroundColor: theme.colorScheme.primary,
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.wifi_tethering),
              label: Text("SEND TEST NOTIFICATION"),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                textStyle: GoogleFonts.jetBrainsMono(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              "Version 1.0.4",
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.secondary.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterSwitch(ThemeData theme) {
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.secondary.withValues(alpha: 0.2);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isMasterEnabled
            ? activeColor.withValues(alpha: 0.1)
            : theme.cardTheme.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isMasterEnabled ? activeColor : inactiveColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ENABLE NOTIFICATIONS",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _isMasterEnabled
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isMasterEnabled ? "ON" : "OFF",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _isMasterEnabled
                      ? activeColor
                      : theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Switch(
            value: _isMasterEnabled,
            activeColor: activeColor,
            onChanged: (val) => _toggleMasterSwitch(val),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(
    BuildContext context, {
    required String title,
    required TimeOfDay time,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.secondary.withValues(alpha: 0.3);

    return InkWell(
      onTap: _isMasterEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(4),
      child: Opacity(
        opacity: _isMasterEnabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.secondary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Text(
                time.format(context),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Opacity(
      opacity: _isMasterEnabled ? 1.0 : 0.5,
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        activeColor: theme.colorScheme.primary,
        value: value,
        onChanged: _isMasterEnabled ? onChanged : null,
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, {required bool isWake}) async {
    final theme = Theme.of(context);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isWake ? _wakeTime : _sleepTime,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              surface: theme.cardTheme.color,
              onSurface: theme.colorScheme.onSurface,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: theme.scaffoldBackgroundColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isWake) {
          _wakeTime = picked;
        } else {
          _sleepTime = picked;
        }
      });
    }
  }
}
