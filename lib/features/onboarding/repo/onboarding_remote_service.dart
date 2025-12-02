import 'dart:async';

class OnboardingRemoteService {
  // Simulate API Call to Gemini
  Future<Map<String, dynamic>> generateStrategy(
    Map<String, dynamic> userProfile,
  ) async {
    print("--- API CALL: SENDING TO GEMINI ---");

    // 1. Simulate Network Delay
    await Future.delayed(const Duration(seconds: 2));

    // 2. Simulate Random Network Failure (10% chance) for robustness testing
    if (DateTime.now().millisecond % 10 == 0) {
      throw Exception("Connection unstable. Intelligence retrieval failed.");
    }

    // 3. Return Mock Response
    return {
      "success": true,
      "strategy_id": "mission_${DateTime.now().millisecondsSinceEpoch}",
      "created_at": DateTime.now().toIso8601String(),
      "profile": userProfile,
      "milestones": [
        {
          "phase": "Foundation",
          "day": 7,
          "focus": "Consistency",
          "desc": "Establish the daily protocol without fail.",
        },
        {
          "phase": "Acceleration",
          "day": 21,
          "focus": "Intensity",
          "desc": "Double the effort. Cut distractions.",
        },
        {
          "phase": "The Grind",
          "day": 45,
          "focus": "Endurance",
          "desc": "Push through the messy middle.",
        },
        {
          "phase": "Final Push",
          "day": 60,
          "focus": "Execution",
          "desc": "Sprint to the deadline.",
        },
      ],
    };
  }
}
