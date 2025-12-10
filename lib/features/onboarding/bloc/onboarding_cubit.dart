import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/onboarding_repo.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepo _repo;

  OnboardingCubit(this._repo) : super(const OnboardingState());

  // --- MISSION UPDATES ---
  void updateObjective(String val) => emit(state.copyWith(objective: val));
  void updateDeepWhy(String val) => emit(state.copyWith(deepWhy: val));
  void updateDeadline(DateTime? date) => emit(state.copyWith(deadline: date));

  // --- PROTOCOL UPDATES ---
  void updateIntensity(String val) => emit(state.copyWith(intensity: val));
  void updateDailyProtocol(String val) =>
      emit(state.copyWith(dailyProtocol: val));

  // --- SCHEDULE UPDATES ---
  void updateWakeTime(TimeOfDay time) => emit(state.copyWith(wakeTime: time));
  void updateSleepTime(TimeOfDay time) => emit(state.copyWith(sleepTime: time));

  void toggleInjectionPreference(String pref) {
    final current = List<String>.from(state.injectionPreferences);
    if (current.contains(pref)) {
      current.remove(pref);
    } else {
      current.add(pref);
    }
    emit(state.copyWith(injectionPreferences: current));
  }

  void updateReviewFrequency(String val) =>
      emit(state.copyWith(reviewFrequency: val));

  // --- ENEMY UPDATES ---
  void toggleWeakness(String weakness) {
    final current = List<String>.from(state.weaknesses);
    if (current.contains(weakness)) {
      current.remove(weakness);
    } else {
      current.add(weakness);
    }
    emit(state.copyWith(weaknesses: current));
  }

  // --- STRATEGY MODIFICATION (REVIEW PHASE) ---

  void modifyTaskToggle(int dayIndex, String taskId) {
    if (state.generatedStrategy == null) return;

    final strategy = Map<String, dynamic>.from(state.generatedStrategy!);
    final brief = List<Map<String, dynamic>>.from(strategy['tactical_brief']);

    for (var i = 0; i < brief.length; i++) {
      if (brief[i]['day'] == dayIndex) {
        final tasks = List<Map<String, dynamic>>.from(brief[i]['tasks']);
        final updatedTasks = tasks.map((t) {
          if (t['id'] == taskId) {
            return {...t, 'is_completed': !(t['is_completed'] as bool)};
          }
          return t;
        }).toList();

        brief[i] = {...brief[i], 'tasks': updatedTasks};
        break;
      }
    }

    strategy['tactical_brief'] = brief;
    emit(
      state.copyWith(
        generatedStrategy: strategy,
        status: OnboardingStatus.updated,
      ),
    );
  }

  void addTaskToDay(int dayIndex, String content) {
    if (state.generatedStrategy == null) return;

    final strategy = Map<String, dynamic>.from(state.generatedStrategy!);
    final brief = List<Map<String, dynamic>>.from(strategy['tactical_brief']);

    for (var i = 0; i < brief.length; i++) {
      if (brief[i]['day'] == dayIndex) {
        final tasks = List<Map<String, dynamic>>.from(brief[i]['tasks']);
        tasks.add({
          "id": "custom_t_${DateTime.now().millisecondsSinceEpoch}",
          "content": content,
          "is_completed": false,
        });
        brief[i] = {...brief[i], 'tasks': tasks};
        break;
      }
    }

    strategy['tactical_brief'] = brief;
    emit(
      state.copyWith(
        generatedStrategy: strategy,
        status: OnboardingStatus.updated,
      ),
    );
  }

  void removeTask(int dayIndex, String taskId) {
    if (state.generatedStrategy == null) return;

    final strategy = Map<String, dynamic>.from(state.generatedStrategy!);
    final brief = List<Map<String, dynamic>>.from(strategy['tactical_brief']);

    for (var i = 0; i < brief.length; i++) {
      if (brief[i]['day'] == dayIndex) {
        final tasks = List<Map<String, dynamic>>.from(brief[i]['tasks']);
        tasks.removeWhere((t) => t['id'] == taskId);
        brief[i] = {...brief[i], 'tasks': tasks};
        break;
      }
    }

    strategy['tactical_brief'] = brief;
    emit(
      state.copyWith(
        generatedStrategy: strategy,
        status: OnboardingStatus.updated,
      ),
    );
  }

  // --- STEP 1: GENERATE (NO SAVE) ---
  Future<void> generateStrategy() async {
    if (state.objective.isEmpty || state.deadline == null) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          errorMessage: "Mission Incomplete",
        ),
      );
      return;
    }

    emit(state.copyWith(status: OnboardingStatus.submitting));

    try {
      final profile = {
        "mission": state.objective,
        "deadline": state.deadline!.toIso8601String(),
        "intensity": state.intensity,
        "protocol": state.dailyProtocol,
        "weaknesses": state.weaknesses,
        "schedule": {
          "wake": "${state.wakeTime.hour}:${state.wakeTime.minute}",
          "sleep": "${state.sleepTime.hour}:${state.sleepTime.minute}",
          "cadence": state.reviewFrequency,
        },
      };

      // Call API only (Remote Service)
      // Note: We access the remote service via the Repo wrapper
      final strategy = await _repo.generateStrategy(profile);

      emit(
        state.copyWith(
          status: OnboardingStatus.generated, // Triggers nav to Review Screen
          generatedStrategy: strategy,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // --- STEP 2: CONFIRM (SAVE LOCAL) ---
  Future<void> confirmStrategy() async {
    if (state.generatedStrategy == null) return;

    emit(state.copyWith(status: OnboardingStatus.submitting));

    try {
      // Save to Hive
      await _repo.saveStrategyProgress(state.generatedStrategy!);
      emit(
        state.copyWith(status: OnboardingStatus.success),
      ); // Triggers nav to Dashboard
    } catch (e) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          errorMessage: "Save failed: $e",
        ),
      );
    }
  }
}
