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

  // --- SUBMISSION ---
  Future<void> submitStrategy() async {
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
      // Build the profile map
      final profile = {
        "mission": state.objective,
        "deadline": state.deadline!.toIso8601String(),
        "intensity": state.intensity,
        "protocol": state.dailyProtocol,
        "weaknesses": state.weaknesses,
        "schedule": {
          "wake": "${state.wakeTime.hour}:${state.wakeTime.minute}",
          "sleep": "${state.sleepTime.hour}:${state.sleepTime.minute}",
        },
      };

      await _repo.generateStrategy(profile);
      emit(state.copyWith(status: OnboardingStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
