import 'package:dmotivation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'themes/app_theme.dart';
import 'features/settings/bloc/theme_cubit.dart';

class DMotivationApp extends StatelessWidget {
  const DMotivationApp({super.key});

  ThemeData _getTheme(String vibe, bool isDark) {
    switch (vibe) {
      case 'Defcon 1':
        return isDark ? AppTheme.defcon1Dark : AppTheme.defcon1Light;
      case 'Cold Truth':
        return isDark ? AppTheme.coldTruthDark : AppTheme.coldTruthLight;
      case 'Terminal Velocity':
      default:
        return isDark
            ? AppTheme.terminalVelocityDark
            : AppTheme.terminalVelocityLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'D/MOTIVATION',
          theme: _getTheme(state.vibe, state.isDark),
          routerConfig: AppRouter.router, // Hook up the router config
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            final clampedScaler = mediaQuery.textScaler.clamp(
              minScaleFactor: 1.0,
              maxScaleFactor: 1.2,
            );
            return MediaQuery(
              data: mediaQuery.copyWith(textScaler: clampedScaler),
              child: child!,
            );
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// THEME SHOWCASE SCREEN (Moved from feature view)
// -----------------------------------------------------------------------------

class ThemeShowcaseScreen extends StatelessWidget {
  const ThemeShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the Cubit and State
    final cubit = context.read<ThemeCubit>();
    final state = context.watch<ThemeCubit>().state;
    final theme = Theme.of(context);
    final isDark = state.isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('D/MOTIVATION'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => cubit.toggleBrightness(),
            tooltip: 'Toggle Brightness',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // THEME CONTROLS
          Card(
            margin: const EdgeInsets.only(bottom: 32),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECT VIBE',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _VibeButton(
                        label: 'Terminal Velocity',
                        isSelected: state.vibe == 'Terminal Velocity',
                        onTap: () => cubit.changeVibe('Terminal Velocity'),
                      ),
                      _VibeButton(
                        label: 'Defcon 1',
                        isSelected: state.vibe == 'Defcon 1',
                        onTap: () => cubit.changeVibe('Defcon 1'),
                      ),
                      _VibeButton(
                        label: 'Cold Truth',
                        isSelected: state.vibe == 'Cold Truth',
                        onTap: () => cubit.changeVibe('Cold Truth'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          _SectionHeader(title: 'SYSTEM STATUS'),
          Text(
            'Current Vibe: ${state.vibe.toUpperCase()}',
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text('Database Sync: Active', style: theme.textTheme.bodyMedium),

          const SizedBox(height: 24),
          _SectionHeader(title: 'TYPOGRAPHY'),
          Text('DISPLAY LARGE', style: theme.textTheme.displayLarge),
          const SizedBox(height: 8),
          Text('DISPLAY MEDIUM', style: theme.textTheme.displayMedium),
          const SizedBox(height: 16),
          Text(
            'Body Large: The quick brown fox jumps over the lazy dog. Deconstruct your excuses.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'COMPONENTS'),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('PRIMARY ACTION'),
              ),
              ElevatedButton(onPressed: null, child: const Text('DISABLED')),
              FloatingActionButton(
                onPressed: () {},
                mini: true,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: theme.colorScheme.secondary),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.secondary,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _VibeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VibeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label.toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
