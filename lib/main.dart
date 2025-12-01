import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  // 1. Initialize Flutter Bindings
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Dependency Injection (DI) Setup
  // In a real implementation, you would initialize your service locator here.
  // Example:
  // await setupServiceLocator(); // Hive, Supabase, LocalNotifications, etc.

  // 3. Run the App
  runApp(const DMotivationDemoApp());
}
