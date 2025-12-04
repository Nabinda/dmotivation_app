import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../onboarding/repo/onboarding_repo.dart';

// Widget Imports
import 'widgets/section_header.dart';
import 'widgets/settings_tile.dart';
import 'widgets/confirm_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // MOCK STATE
  bool _isPro = false;
  int _adsWatched = 1;
  final int _adsRequired = 4;
  final int _daysLeftInTrial = 2;
  final String _userIdentity = "USER_8X92";

  void _abortMission(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmDialog(
        title: "ABORT MISSION?",
        body:
            "This will wipe all strategic data and progress. This action cannot be undone.",
        confirmText: "CONFIRM WIPE",
        isDanger: true,
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<OnboardingRepo>().resetStrategy();
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final secondaryTextColor = theme.brightness == Brightness.light
        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
        : theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "SYSTEM CONFIG",
          style: theme.textTheme.titleMedium?.copyWith(
            letterSpacing: 2.0,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IDENTITY CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                border: Border.all(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _isPro
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.secondary.withValues(alpha: 0.1),
                    child: Icon(
                      _isPro ? Icons.verified : Icons.lock_clock,
                      size: 32,
                      color: _isPro
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _userIdentity,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // TIER BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _isPro
                          ? Colors.amber.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _isPro ? Colors.amber : Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _isPro ? "PRO TIER" : "FREE TIER",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _isPro ? Colors.amber : Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  // ADS TRACKER
                  if (!_isPro) ...[
                    const SizedBox(height: 16),
                    Divider(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "DAILY AD LIMIT",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                        Text(
                          "$_adsWatched / $_adsRequired",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _adsWatched / _adsRequired,
                      backgroundColor: theme.colorScheme.secondary.withValues(
                        alpha: 0.2,
                      ),
                      valueColor: const AlwaysStoppedAnimation(Colors.red),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Trial expires in $_daysLeftInTrial days. Watch ads to extend.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            // OPERATOR INTELLIGENCE (Pro Only)
            if (_isPro) ...[
              const SectionHeader(title: "OPERATOR INTELLIGENCE"),
              SettingsTile(
                icon: Icons.bar_chart,
                title: "Tactical Analytics",
                subtitle: "View performance metrics and consistency.",
                iconColor: theme.colorScheme.primary,
                onTap: () {
                  // WIRED: Navigate to Analytics
                  context.push('/analytics');
                },
              ),
              SettingsTile(
                icon: Icons.psychology,
                title: "Panic Logs",
                subtitle: "Review emotional triggers and interventions.",
                iconColor: theme.colorScheme.primary,
                onTap: () {
                  // WIRED: Navigate to Panic Logs
                  context.push('/panic-logs');
                },
              ),
              const SizedBox(height: 32),
            ],

            const SectionHeader(title: "ACCOUNT"),

            if (!_isPro)
              SettingsTile(
                icon: Icons.play_circle_outline,
                title: "Watch Ad",
                subtitle: "Extend access (+$_adsRequired hrs).",
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {
                  setState(
                    () =>
                        _adsWatched = (_adsWatched + 1).clamp(0, _adsRequired),
                  );
                },
              ),

            SettingsTile(
              icon: _isPro ? Icons.verified_user : Icons.diamond_outlined,
              title: _isPro ? "Manage Plan" : "Upgrade Plan",
              subtitle: _isPro
                  ? "View details or cancel subscription."
                  : "Remove ads & unlock full access.",
              textColor: _isPro ? null : theme.colorScheme.primary,
              iconColor: _isPro ? null : theme.colorScheme.primary,
              onTap: () async {
                if (_isPro) {
                  final result = await context.push<bool>(
                    '/manage-subscription',
                  );
                  if (result == true && mounted) {
                    setState(() => _isPro = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "SUBSCRIPTION CANCELLED. RETURNED TO FREE TIER.",
                        ),
                        backgroundColor: theme.colorScheme.error,
                      ),
                    );
                  }
                } else {
                  final result = await context.push<bool>('/paywall');
                  if (result == true && mounted) {
                    setState(() => _isPro = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("WELCOME, OPERATOR."),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                    );
                  }
                }
              },
            ),

            SettingsTile(
              icon: Icons.vpn_key,
              title: "Link Account",
              subtitle: "Sync progress to cloud.",
              onTap: () {},
            ),

            const SizedBox(height: 32),
            const SectionHeader(title: "PREFERENCES"),
            SettingsTile(
              icon: Icons.palette,
              title: "Theme / Visuals",
              subtitle: "Change app appearance.",
              onTap: () {
                context.push('/dump');
              },
            ),
            SettingsTile(
              icon: Icons.notifications,
              title: "Notifications",
              subtitle: "Manage alert timing.",
              onTap: () {},
            ),

            const SizedBox(height: 32),
            const SectionHeader(title: "DANGER ZONE"),
            SettingsTile(
              icon: Icons.delete_forever,
              title: "Reset Progress",
              subtitle: "Wipe all local data.",
              textColor: theme.colorScheme.error,
              iconColor: theme.colorScheme.error,
              onTap: () => _abortMission(context),
            ),

            const SizedBox(height: 48),
            Center(
              child: Text(
                "v1.0.0 (Build 102)",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: secondaryTextColor.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
