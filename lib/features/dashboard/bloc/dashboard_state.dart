enum DashboardStatus { loading, loaded, error }

class DashboardState {
  final DashboardStatus status;
  final Map<String, dynamic>? strategy; // The full JSON object
  final int daysRemaining;
  final int currentDayIndex; // Day 1, Day 5, etc.
  final Map<String, dynamic>? currentPhase; // "The Grind" object
  final List<Map<String, dynamic>> todaysTasks; // Filtered list for UI

  const DashboardState({
    this.status = DashboardStatus.loading,
    this.strategy,
    this.daysRemaining = 0,
    this.currentDayIndex = 1,
    this.currentPhase,
    this.todaysTasks = const [],
  });

  DashboardState copyWith({
    DashboardStatus? status,
    Map<String, dynamic>? strategy,
    int? daysRemaining,
    int? currentDayIndex,
    Map<String, dynamic>? currentPhase,
    List<Map<String, dynamic>>? todaysTasks,
  }) {
    return DashboardState(
      status: status ?? this.status,
      strategy: strategy ?? this.strategy,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
      currentPhase: currentPhase ?? this.currentPhase,
      todaysTasks: todaysTasks ?? this.todaysTasks,
    );
  }
}
