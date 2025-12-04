import 'package:flutter_bloc/flutter_bloc.dart';
import '../../onboarding/repo/onboarding_repo.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final OnboardingRepo _repo;

  DashboardCubit(this._repo) : super(const DashboardState());

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: DashboardStatus.loading));

    try {
      final strategy = _repo.getActiveStrategy();

      if (strategy == null) {
        emit(state.copyWith(status: DashboardStatus.error));
        return;
      }

      // 1. Time Metrics
      final createdString =
          strategy['meta']?['created_at'] ?? DateTime.now().toIso8601String();
      final deadlineString = strategy['profile']['deadline'];

      final startDate = _normalizeDate(DateTime.parse(createdString));
      final deadline = _normalizeDate(DateTime.parse(deadlineString));
      final now = _normalizeDate(DateTime.now());

      final daysRemaining = deadline.difference(now).inDays;
      final currentDayIndex = now.difference(startDate).inDays + 1;

      // 2. Identify Current Phase
      final milestones = List<Map<String, dynamic>>.from(
        strategy['milestones'],
      );
      Map<String, dynamic>? activePhase = milestones.isNotEmpty
          ? milestones.last
          : null;

      double calculatedProgress = 0.0;
      int phaseStartDay = 1;

      for (var i = 0; i < milestones.length; i++) {
        final m = milestones[i];
        final phaseEndDay = m['day_offset'] as int;

        if (i > 0) {
          phaseStartDay = (milestones[i - 1]['day_offset'] as int) + 1;
        }

        if (currentDayIndex <= phaseEndDay) {
          activePhase = m;

          final totalDaysInPhase = phaseEndDay - phaseStartDay + 1;
          final daysIntoPhase = currentDayIndex - phaseStartDay + 1;

          if (totalDaysInPhase > 0) {
            calculatedProgress = (daysIntoPhase / totalDaysInPhase).clamp(
              0.0,
              1.0,
            );
          }
          break;
        }
      }

      // 3. Get Tasks for TODAY (Default)
      // Note: We default selectedDayIndex to currentDayIndex on load
      final tasks = _getTasksForDay(currentDayIndex, strategy);
      final isDayComplete =
          tasks.isNotEmpty && tasks.every((t) => t['is_completed'] == true);

      emit(
        state.copyWith(
          status: DashboardStatus.loaded,
          strategy: strategy,
          daysRemaining: daysRemaining,
          currentDayIndex: currentDayIndex,
          selectedDayIndex: currentDayIndex, // Start at today
          currentPhase: activePhase,
          phaseProgress: calculatedProgress,
          todaysTasks: tasks,
          isDayComplete: isDayComplete,
        ),
      );
    } catch (e) {
      print("Dashboard Load Error: $e");
      emit(state.copyWith(status: DashboardStatus.error));
    }
  }

  // Helper to extract tasks for any given day index
  List<Map<String, dynamic>> _getTasksForDay(
    int dayIndex,
    Map<String, dynamic> strategy,
  ) {
    final tacticalBrief = List<Map<String, dynamic>>.from(
      strategy['tactical_brief'],
    );
    try {
      final dayData = tacticalBrief.firstWhere(
        (e) => (e['day'] as int) == dayIndex,
        orElse: () => {},
      );
      if (dayData.isNotEmpty && dayData['tasks'] != null) {
        return List<Map<String, dynamic>>.from(dayData['tasks']);
      }
    } catch (e) {
      // No tasks found
    }
    return [];
  }

  // NEW: Navigate History
  void selectDay(int dayIndex) {
    if (state.strategy == null) return;

    // Don't allow selecting days beyond the mission scope or negative days
    if (dayIndex < 1) return;

    final tasks = _getTasksForDay(dayIndex, state.strategy!);
    final isDayComplete =
        tasks.isNotEmpty && tasks.every((t) => t['is_completed'] == true);

    emit(
      state.copyWith(
        selectedDayIndex: dayIndex,
        todaysTasks: tasks,
        isDayComplete: isDayComplete,
      ),
    );
  }

  void toggleTask(String taskId) {
    if (state.strategy == null) return;

    final updatedStrategy = Map<String, dynamic>.from(state.strategy!);
    final briefing = List<Map<String, dynamic>>.from(
      updatedStrategy['tactical_brief'],
    );

    List<Map<String, dynamic>> updatedUiTasks = [];
    bool stateChanged = false;

    for (var i = 0; i < briefing.length; i++) {
      final dayData = Map<String, dynamic>.from(briefing[i]);
      final tasks = List<Map<String, dynamic>>.from(dayData['tasks']);

      bool taskFoundInDay = false;

      final newTasks = tasks.map((t) {
        if (t['id'] == taskId) {
          taskFoundInDay = true;
          stateChanged = true;
          return {...t, 'is_completed': !(t['is_completed'] as bool)};
        }
        return t;
      }).toList();

      if (taskFoundInDay) {
        dayData['tasks'] = newTasks;
        briefing[i] = dayData;

        // If the toggled task belongs to the currently viewed day, update UI
        if (dayData['day'] == state.selectedDayIndex) {
          updatedUiTasks = newTasks;
        }
        break;
      }
    }

    if (!stateChanged) return;

    updatedStrategy['tactical_brief'] = briefing;

    final isComplete =
        updatedUiTasks.isNotEmpty &&
        updatedUiTasks.every((t) => t['is_completed'] == true);

    emit(
      state.copyWith(
        strategy: updatedStrategy,
        todaysTasks: updatedUiTasks.isNotEmpty
            ? updatedUiTasks
            : state.todaysTasks,
        isDayComplete: isComplete,
      ),
    );

    _repo.saveStrategyProgress(updatedStrategy);
  }
}
