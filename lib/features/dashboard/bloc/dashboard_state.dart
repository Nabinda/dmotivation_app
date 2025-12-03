
enum DashboardStatus { loading, loaded, error }

class DashboardState {
  final DashboardStatus status;
  final Map<String, dynamic>? strategy;
  final int daysRemaining;
  final int currentDayIndex; // The actual "Today" (e.g. Day 5)
  final int selectedDayIndex; // The day being viewed (e.g. Day 2)
  final Map<String, dynamic>? currentPhase;
  final double phaseProgress;
  final List<Map<String, dynamic>> todaysTasks; // Tasks for the SELECTED day
  final bool isDayComplete;

  const DashboardState({
    this.status = DashboardStatus.loading,
    this.strategy,
    this.daysRemaining = 0,
    this.currentDayIndex = 1,
    this.selectedDayIndex = 1, // Default
    this.currentPhase,
    this.phaseProgress = 0.0,
    this.todaysTasks = const [],
    this.isDayComplete = false,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    Map<String, dynamic>? strategy,
    int? daysRemaining,
    int? currentDayIndex,
    int? selectedDayIndex,
    Map<String, dynamic>? currentPhase,
    double? phaseProgress,
    List<Map<String, dynamic>>? todaysTasks,
    bool? isDayComplete,
  }) {
    return DashboardState(
      status: status ?? this.status,
      strategy: strategy ?? this.strategy,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      currentPhase: currentPhase ?? this.currentPhase,
      phaseProgress: phaseProgress ?? this.phaseProgress,
      todaysTasks: todaysTasks ?? this.todaysTasks,
      isDayComplete: isDayComplete ?? this.isDayComplete,
    );
  }
}
