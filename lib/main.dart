import 'package:dmotivation/features/onboarding/repo/onboarding_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/settings/repo/settings_service.dart';
import 'features/settings/bloc/theme_cubit.dart';
// Import the Onboarding Repo
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Local Database (Settings)
  final settingsService = SettingsService();
  await settingsService.init();

  // 2. Initialize Repositories (Data Layer)
  // We create instances here so they live as long as the app lives.
  final onboardingRepo = OnboardingRepo();
  await onboardingRepo.init(); // Initialize Hive box for strategies
  // 3. Run App with Providers
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OnboardingRepo>.value(value: onboardingRepo),
        // Add other repos here (e.g. AuthRepo, MissionRepo)
      ],
      child: BlocProvider(
        // ThemeCubit is Global because it affects the whole app style
        create: (context) => ThemeCubit(settingsService),
        child: const DMotivationApp(),
      ),
    ),
  );
}
