import 'dart:async';

class OnboardingRemoteService {
  // Simulate API Call to Gemini
  Future<Map<String, dynamic>> generateStrategy(
    Map<String, dynamic> userProfile,
  ) async {

    // 1. Simulate Network Delay
    await Future.delayed(const Duration(seconds: 2));

    // Extract user preferences to customize the mock response
    final schedule = userProfile['schedule'] as Map<String, dynamic>;
    final cadence = schedule['cadence'] ?? 'Daily'; // Daily or Weekly
    final weaknesses = List<String>.from(userProfile['weaknesses'] ?? []);
    final primaryWeakness = weaknesses.isNotEmpty
        ? weaknesses.first
        : "Procrastination";

    // 3. Return Mock Response (DB Ready Structure)
    return {
      "success": true,
      "meta": {
        "version": "1.0",
        "generated_by": "gemini-1.5-flash",
        "strategy_id": "mission_${DateTime.now().millisecondsSinceEpoch}",
        "created_at": DateTime.now().toIso8601String(),
      },
      "profile": userProfile,

      // A. The Timeline (Phases)
      "milestones": [
        {
          "phase": "Foundation",
          "day_offset": 7,
          "color": "blue",
          "focus": "Consistency",
          "desc": "Establish the daily protocol without fail. Ignore feelings.",
        },
        {
          "phase": "Acceleration",
          "day_offset": 21,
          "color": "green",
          "focus": "Intensity",
          "desc":
              "Double the effort. Cut all distractions. $primaryWeakness is the enemy.",
        },
        {
          "phase": "The Grind",
          "day_offset": 45,
          "color": "orange",
          "focus": "Endurance",
          "desc": "Push through the messy middle. This is where most quit.",
        },
        {
          "phase": "Final Push",
          "day_offset": 60,
          "color": "red",
          "focus": "Execution",
          "desc": "Sprint to the deadline. No mercy.",
        },
      ],

      // B. Strategic Injections (Notifications)
      "injections": [
        // Day 1
        {
          "id": "inj_d1_m",
          "day": 1,
          "slot": "morning",
          "trigger_offset": "00:30",
          "title": "Day 1. Execute.",
          "body":
              "The contract is signed. $primaryWeakness will try to stop you today. Don't let it.",
          "intent": "kickoff",
        },
        {
          "id": "inj_d1_e",
          "day": 1,
          "slot": "evening",
          "trigger_offset": "-02:00",
          "title": "Report Status.",
          "body": "Did you complete the protocol? Be honest with yourself.",
          "intent": "accountability",
        },
        // Day 2
        {
          "id": "inj_d2_md",
          "day": 2,
          "slot": "mid_day",
          "trigger_offset": "06:00",
          "title": "Focus Check.",
          "body": "Are you working or just busy? Get back to the mission.",
          "intent": "correction",
        },
      ],

      // C. Tactical Brief (Todo Breakdown)
      // UPDATED: Tasks are now objects with IDs and completion status
      "tactical_brief": cadence == 'Daily'
          ? [
              {
                "day": 1,
                "tasks": [
                  {
                    "id": "t_d1_1",
                    "content": "Set up workspace",
                    "is_completed": false,
                  },
                  {
                    "id": "t_d1_2",
                    "content": "Complete Protocol (Day 1)",
                    "is_completed": false,
                  },
                  {
                    "id": "t_d1_3",
                    "content": "No social media after 8PM",
                    "is_completed": false,
                  },
                ],
              },
              {
                "day": 2,
                "tasks": [
                  {
                    "id": "t_d2_1",
                    "content": "Review yesterday's failure points",
                    "is_completed": false,
                  },
                  {
                    "id": "t_d2_2",
                    "content": "Complete Protocol (Day 2)",
                    "is_completed": false,
                  },
                  {
                    "id": "t_d2_3",
                    "content": "Drink 3L Water",
                    "is_completed": false,
                  },
                ],
              },
              {
                "day": 3,
                "tasks": [
                  {
                    "id": "t_d3_1",
                    "content": "Complete Protocol (Day 3)",
                    "is_completed": false,
                  },
                  {
                    "id": "t_d3_2",
                    "content": "Visualise the Deadline",
                    "is_completed": false,
                  },
                ],
              },
            ]
          : [
              {
                "week": 1,
                "focus": "Systems",
                "tasks": [
                  {
                    "id": "t_w1_1",
                    "content": "Build the habit loop",
                    "is_completed": false,
                  },
                  {
                    "id": "t_w1_2",
                    "content": "Remove 1 major distraction",
                    "is_completed": false,
                  },
                  {
                    "id": "t_w1_3",
                    "content": "Hit 90% Protocol compliance",
                    "is_completed": false,
                  },
                ],
              },
              {
                "week": 2,
                "focus": "Volume",
                "tasks": [
                  {
                    "id": "t_w2_1",
                    "content": "Increase output by 10%",
                    "is_completed": false,
                  },
                  {
                    "id": "t_w2_2",
                    "content": "Wake up 15m earlier",
                    "is_completed": false,
                  },
                  {
                    "id": "t_w2_3",
                    "content": "Zero missed days",
                    "is_completed": false,
                  },
                ],
              },
            ],
    };
  }
}
