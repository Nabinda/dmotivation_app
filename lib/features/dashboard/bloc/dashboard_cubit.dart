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

      // Calculate Progress variables
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

  // NEW: Smart Task Fetcher (Handles Daily vs Weekly)
  List<Map<String, dynamic>> _getTasksForDay(
    int dayIndex,
    Map<String, dynamic> strategy,
  ) {
    final tacticalBrief = List<Map<String, dynamic>>.from(
      strategy['tactical_brief'],
    );

    // Check Cadence
    final profile = strategy['profile'] as Map<String, dynamic>;
    final schedule = profile['schedule'] as Map<String, dynamic>;
    final isWeekly = schedule['cadence'] == 'Weekly';

    try {
      Map<String, dynamic> data = {};

      if (isWeekly) {
        // Calculate Week Index (1-based)
        // Day 1-7 = Week 1, Day 8-14 = Week 2
        final weekIndex = ((dayIndex - 1) / 7).floor() + 1;

        data = tacticalBrief.firstWhere(
          (e) => (e['week'] as int) == weekIndex,
          orElse: () => {},
        );
      } else {
        // Daily Logic
        data = tacticalBrief.firstWhere(
          (e) => (e['day'] as int) == dayIndex,
          orElse: () => {},
        );
      }

      if (data.isNotEmpty && data['tasks'] != null) {
        return List<Map<String, dynamic>>.from(data['tasks']);
      }
    } catch (e) {
      print("Task Fetch Error: $e");
    }
    return [];
  }

  void selectDay(int dayIndex) {
    if (state.strategy == null) return;
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

    // Check Cadence for logic
    final profile = state.strategy!['profile'];
    final schedule = profile['schedule'];
    final isWeekly = schedule['cadence'] == 'Weekly';

    // Calculate current viewing context (Day or Week)
    final currentWeekIndex = ((state.selectedDayIndex - 1) / 7).floor() + 1;

    for (var i = 0; i < briefing.length; i++) {
      final periodData = Map<String, dynamic>.from(briefing[i]);
      final tasks = List<Map<String, dynamic>>.from(periodData['tasks']);

      bool taskFound = false;

      final newTasks = tasks.map((t) {
        if (t['id'] == taskId) {
          taskFound = true;
          stateChanged = true;
          return {...t, 'is_completed': !(t['is_completed'] as bool)};
        }
        return t;
      }).toList();

      if (taskFound) {
        periodData['tasks'] = newTasks;
        briefing[i] = periodData;

        // Check if this update affects the currently viewed list
        bool shouldUpdateUi = false;
        if (isWeekly) {
          if (periodData['week'] == currentWeekIndex) shouldUpdateUi = true;
        } else {
          if (periodData['day'] == state.selectedDayIndex)
            shouldUpdateUi = true;
        }

        if (shouldUpdateUi) {
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
