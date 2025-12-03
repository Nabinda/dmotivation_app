import 'package:flutter/material.dart';

enum OnboardingStatus { initial, submitting, success, failure }

class OnboardingState {
  // Mission
  final String objective;
  final String deepWhy;
  final DateTime? deadline;

  // Protocol
  final String intensity;
  final String dailyProtocol;

  // Schedule
  final TimeOfDay wakeTime;
  final TimeOfDay sleepTime;
  final List<String> injectionPreferences;
  // NEW: How often they want to check tasks
  final String reviewFrequency;

  // Enemy
  final List<String> weaknesses;

  // Submission Status
  final OnboardingStatus status;
  final String? errorMessage;

  const OnboardingState({
    this.objective = '',
    this.deepWhy = '',
    this.deadline,
    this.intensity = 'High',
    this.dailyProtocol = '',
    this.wakeTime = const TimeOfDay(hour: 7, minute: 0),
    this.sleepTime = const TimeOfDay(hour: 23, minute: 0),
    this.injectionPreferences = const ['Morning Kickoff', 'Evening Review'],
    this.reviewFrequency = 'Daily', // Default to Daily
    this.weaknesses = const [],
    this.status = OnboardingStatus.initial,
    this.errorMessage,
  });

  OnboardingState copyWith({
    String? objective,
    String? deepWhy,
    DateTime? deadline,
    String? intensity,
    String? dailyProtocol,
    TimeOfDay? wakeTime,
    TimeOfDay? sleepTime,
    List<String>? injectionPreferences,
    String? reviewFrequency,
    List<String>? weaknesses,
    OnboardingStatus? status,
    String? errorMessage,
  }) {
    return OnboardingState(
      objective: objective ?? this.objective,
      deepWhy: deepWhy ?? this.deepWhy,
      deadline: deadline ?? this.deadline,
      intensity: intensity ?? this.intensity,
      dailyProtocol: dailyProtocol ?? this.dailyProtocol,
      wakeTime: wakeTime ?? this.wakeTime,
      sleepTime: sleepTime ?? this.sleepTime,
      injectionPreferences: injectionPreferences ?? this.injectionPreferences,
      reviewFrequency: reviewFrequency ?? this.reviewFrequency,
      weaknesses: weaknesses ?? this.weaknesses,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
