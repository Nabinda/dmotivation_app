import 'package:dmotivation/features/dashboard/view/painter/warning_triangle_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Logic
import '../../onboarding/repo/onboarding_repo.dart';
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';

// Widgets
import 'widgets/mission_hud.dart';
import 'widgets/phase_status_card.dart';
import 'widgets/tactical_checklist.dart';
import 'widgets/timeline_sheet.dart';
import '../../panic/view/panic_sheet.dart'; // Ensure you have the Panic feature created

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DashboardCubit(context.read<OnboardingRepo>())..loadDashboard(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  void _showTimeline(BuildContext context, DashboardState state) {
    if (state.strategy == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TimelineSheet(
        milestones: state.strategy!['milestones'],
        currentDay: state.currentDayIndex,
      ),
    );
  }

  void _showPanicMode(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PanicSheet(),
    );
  }

  // Date Picker Logic
  Future<void> _pickDate(BuildContext context, DashboardState state) async {
    if (state.strategy == null) return;

    final createdStr = state.strategy!['meta']['created_at'];
    final start = DateTime.parse(createdStr);
    final end = DateTime.parse(state.strategy!['profile']['deadline']);

    final currentViewDate = start.add(
      Duration(days: state.selectedDayIndex - 1),
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: currentViewDate,
      firstDate: start,
      lastDate: end,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final diff = picked
          .difference(DateTime(start.year, start.month, start.day))
          .inDays;
      context.read<DashboardCubit>().selectDay(diff + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "COMMAND CENTER",
          style: theme.textTheme.titleMedium?.copyWith(
            letterSpacing: 2.0,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/dump'),
          ),
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (state.status == DashboardStatus.error || state.strategy == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text("STRATEGY NOT FOUND"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/onboarding'),
                    child: const Text("INITIALIZE NEW MISSION"),
                  ),
                ],
              ),
            );
          }

          final profile = state.strategy!['profile'];
          final missionTitle = profile['mission'] ?? 'CLASSIFIED';

          final isViewingToday =
              state.selectedDayIndex == state.currentDayIndex;
          final isDayFailed =
              state.selectedDayIndex < state.currentDayIndex &&
              !state.isDayComplete;

          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
            color: theme.colorScheme.primary,
            backgroundColor: theme.cardTheme.color,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HUD with Date Picker
                  MissionHUD(
                    missionTitle: missionTitle,
                    daysRemaining: state.daysRemaining,
                    dayIndex: state.selectedDayIndex,
                    onDateTap: () => _pickDate(context, state),
                  ),

                  // 2. Phase Status
                  if (state.currentPhase != null) ...[
                    PhaseStatusCard(
                      phaseData: state.currentPhase!,
                      progress: state.phaseProgress,
                      onTimelineTap: () => _showTimeline(context, state),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // 3. Visual Reward / Failure
                  if (state.isDayComplete) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.verified,
                            color: theme.colorScheme.primary,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "MISSION ACCOMPLISHED",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "DAY ${state.selectedDayIndex} PROTOCOL COMPLETE. STAND DOWN.",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ] else if (isDayFailed) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withValues(alpha: 0.1),
                        border: Border.all(
                          color: theme.colorScheme.error,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: theme.colorScheme.error,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "PROTOCOL FAILED",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "DAY ${state.selectedDayIndex} OBJECTIVES INCOMPLETE.",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],

                  // 4. Checklist (Cleaned up)
                  TacticalChecklist(
                    tasks: state.todaysTasks,
                    isReadOnly: !isViewingToday,
                    onToggle: (id) =>
                        context.read<DashboardCubit>().toggleTask(id),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          backgroundColor: theme.colorScheme.error,
          onPressed: () => _showPanicMode(context),
          shape: const WarningTriangleShape(cornerRadius: 5.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(
              Icons.priority_high_rounded,
              size: 26,
              color: theme.colorScheme.onError,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
