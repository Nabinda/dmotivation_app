import 'package:dmotivation/features/settings/bloc/theme_cubit.dart';
import 'package:dmotivation/features/settings/repo/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';

void main() async {
  // 1. Initialize Flutter Bindings
  WidgetsFlutterBinding.ensureInitialized();
  // 1. Initialize Local Database (Repository/Service Layer)
  final settingsService = SettingsService();
  await settingsService.init();

  // 2. Run App with Cubit Injection (Bloc Layer)
  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(settingsService),
      child: const DMotivationApp(),
    ),
  );
}
