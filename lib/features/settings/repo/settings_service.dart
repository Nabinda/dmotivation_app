import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static const String _boxName = 'settings';
  static const String _keyVibe = 'vibe';
  static const String _keyIsDark = 'is_dark';

  // Initialize Hive (Call this in main.dart)
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  // Getters (Synchronous - fast!)
  String getVibe() {
    return Hive.box(_boxName).get(_keyVibe, defaultValue: 'Terminal Velocity');
  }

  bool getIsDarkMode() {
    return Hive.box(_boxName).get(_keyIsDark, defaultValue: true);
  }

  // Setters
  Future<void> saveVibe(String vibe) async {
    await Hive.box(_boxName).put(_keyVibe, vibe);
  }

  Future<void> saveIsDarkMode(bool isDark) async {
    await Hive.box(_boxName).put(_keyIsDark, isDark);
  }
}
