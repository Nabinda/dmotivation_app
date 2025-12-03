import 'package:flutter_bloc/flutter_bloc.dart';
import '../../onboarding/repo/onboarding_repo.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final OnboardingRepo _repo;

  DashboardCubit(this._repo) : super(const DashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: DashboardStatus.loading));

    try {
      final strategy = _repo.getActiveStrategy();

      if (strategy == null) {
        emit(
          state.copyWith(status: DashboardStatus.error),
        ); // Or redirect to onboarding
        return;
      }

      // 1. Calculate Time Metrics
      final createdString =
          strategy['meta']?['created_at'] ?? DateTime.now().toIso8601String();
      final deadlineString = strategy['profile']['deadline'];

      final startDate = DateTime.parse(createdString);
      final deadline = DateTime.parse(deadlineString);
      final now = DateTime.now();

      final daysRemaining = deadline.difference(now).inDays;
      final currentDayIndex =
          now.difference(startDate).inDays + 1; // Day 1 is start

      // 2. Identify Current Phase
      // Logic: Find the milestone where day_offset is closest but greater than currentDayIndex
      final milestones = List<Map<String, dynamic>>.from(
        strategy['milestones'],
      );
      Map<String, dynamic>? activePhase = milestones.first;

      for (var m in milestones) {
        if (currentDayIndex >= (m['day_offset'] as int)) {
          activePhase = m; // Update as we pass milestones
        }
      }

      // 3. Filter Tasks for "Today" (or current Week)
      // Note: In a real app, this logic handles Week 1 vs Day 1 based on Cadence.
      // For MVP, we just grab the first batch as a demo if Day 1 matches.
      final tacticalBrief = List<Map<String, dynamic>>.from(
        strategy['tactical_brief'],
      );

      // Simple lookup for demo: Find tasks matching current day index
      // In production, you'd have robust date matching here.
      List<Map<String, dynamic>> tasks = [];
      try {
        final dayData = tacticalBrief.firstWhere(
          (e) => (e['day'] as int) == currentDayIndex,
          orElse: () => tacticalBrief.first, // Fallback to first day for demo
        );
        tasks = List<Map<String, dynamic>>.from(dayData['tasks']);
      } catch (e) {
        // Fallback or empty if no tasks for this specific day
      }

      emit(
        state.copyWith(
          status: DashboardStatus.loaded,
          strategy: strategy,
          daysRemaining: daysRemaining,
          currentDayIndex: currentDayIndex,
          currentPhase: activePhase,
          todaysTasks: tasks,
        ),
      );
    } catch (e) {
      print("Dashboard Load Error: $e");
      emit(state.copyWith(status: DashboardStatus.error));
    }
  }

  void toggleTask(String taskId) {
    if (state.strategy == null) return;

    // 1. Create a deep copy of the strategy to modify
    // (We modify the 'tactical_brief' section)
    final updatedStrategy = Map<String, dynamic>.from(state.strategy!);
    final briefing = List<Map<String, dynamic>>.from(
      updatedStrategy['tactical_brief'],
    );

    // 2. Find the day and the task
    // We iterate through days to find the task with the matching ID
    for (var i = 0; i < briefing.length; i++) {
      final dayData = briefing[i];
      final tasks = List<Map<String, dynamic>>.from(dayData['tasks']);

      bool taskFound = false;
      final updatedTasks = tasks.map((t) {
        if (t['id'] == taskId) {
          taskFound = true;
          return {...t, 'is_completed': !t['is_completed']};
        }
        return t;
      }).toList();

      if (taskFound) {
        // Update the day's task list in the main briefing array
        briefing[i] = {...dayData, 'tasks': updatedTasks};

        // Also update the 'todaysTasks' for the UI immediately (Optimistic Update)
        if (dayData['day'] == state.currentDayIndex) {
          emit(state.copyWith(todaysTasks: updatedTasks));
        }
        break;
      }
    }

    // 3. Reassemble and Save
    updatedStrategy['tactical_brief'] = briefing;

    // Update local state so the full strategy is fresh
    emit(state.copyWith(strategy: updatedStrategy));

    // 4. Persist to Hive (Fire and forget)
    _repo.saveStrategyProgress(updatedStrategy);
  }
}
