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

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Cubit
    return BlocProvider(
      create: (context) =>
          DashboardCubit(context.read<OnboardingRepo>())
            ..loadDashboard(), // Trigger load immediately
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
            onPressed: () {
              context.push('/dump');
            },
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

          // Data Extraction
          final profile = state.strategy!['profile'];
          final missionTitle = profile['mission'] ?? 'CLASSIFIED';

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
                  // 1. HUD
                  MissionHUD(
                    missionTitle: missionTitle,
                    daysRemaining: state.daysRemaining,
                    dayIndex: state.currentDayIndex,
                  ),

                  // 2. Phase Status
                  if (state.currentPhase != null) ...[
                    PhaseStatusCard(
                      phaseData: state.currentPhase!,
                      onTimelineTap: () => _showTimeline(context, state),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // 3. Checklist
                  TacticalChecklist(
                    tasks: state.todaysTasks,
                    onToggle: (id) =>
                        context.read<DashboardCubit>().toggleTask(id),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Open "Panic Button" / State Reset
        },
        backgroundColor: theme.colorScheme.error,
        child: Icon(Icons.priority_high, color: theme.colorScheme.onError),
      ),
    );
  }
}
