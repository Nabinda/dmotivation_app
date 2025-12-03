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
