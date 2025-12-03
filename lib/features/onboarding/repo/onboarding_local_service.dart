import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class OnboardingLocalService {
  static const String _boxName = 'user_strategy';
  static const String _keyStrategy = 'active_strategy';

  // Initialize Hive Box
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  // Save Strategy JSON
  Future<void> saveStrategy(Map<String, dynamic> strategy) async {
    final box = Hive.box(_boxName);
    await box.put(_keyStrategy, jsonEncode(strategy));
  }

  // Retrieve Strategy JSON
  Map<String, dynamic>? getStrategy() {
    if (!Hive.isBoxOpen(_boxName)) return null;

    final box = Hive.box(_boxName);
    final String? data = box.get(_keyStrategy);

    if (data == null) return null;
    return jsonDecode(data);
  }

  // Update existing strategy (for checklist toggles)
  Future<void> updateStrategy(Map<String, dynamic> strategy) async {
    final box = Hive.box(_boxName);
    await box.put(_keyStrategy, jsonEncode(strategy));
  }

  // Clear Storage
  Future<void> clearStrategy() async {
    if (Hive.isBoxOpen(_boxName)) {
      final box = Hive.box(_boxName);
      await box.delete(_keyStrategy);
    }
  }
}
