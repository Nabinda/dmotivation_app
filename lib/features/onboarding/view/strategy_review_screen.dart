import 'package:dmotivation/features/onboarding/view/widgets/strategy_day_editor.dart';
import 'package:dmotivation/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/onboarding_cubit.dart';
import '../bloc/onboarding_state.dart';
import 'widgets/bottom_action.dart';
import 'widgets/strategy_section_header.dart';

class StrategyReviewScreen extends StatefulWidget {
  final OnboardingCubit onboardingCubit;

  const StrategyReviewScreen({super.key, required this.onboardingCubit});

  @override
  State<StrategyReviewScreen> createState() => _StrategyReviewScreenState();
}

class _StrategyReviewScreenState extends State<StrategyReviewScreen> {
  int _visibleDayCount = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: widget.onboardingCubit,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "REVIEW PROTOCOL",
            style: theme.textTheme.titleMedium?.copyWith(
              letterSpacing: 2.0,
              color: theme.colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocListener<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state.status == OnboardingStatus.success) {
              context.go('/home');
            }
          },
          child: CustomScrollView(
            key: const PageStorageKey('strategy_review_scroll'),
            slivers: [
              SliverToBoxAdapter(
                child: BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    if (state.generatedStrategy == null) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const Center(child: Text("No Strategy Data")),
                      );
                    }

                    final strategy = state.generatedStrategy!;
                    final milestones = List.from(strategy['milestones'] ?? []);
                    final briefing = List.from(
                      strategy['tactical_brief'] ?? [],
                    );

                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MISSION PARAMETERS GENERATED.\nREVIEW AND EDIT BEFORE COMMITMENT.",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // 1. TIMELINE SECTION
                          StrategySectionHeader(title: "OPERATIONAL TIMELINE"),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.cardTheme.color,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: theme.colorScheme.secondary.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Column(
                              children: milestones.asMap().entries.map<Widget>((
                                entry,
                              ) {
                                final index = entry.key;
                                final m = entry.value;
                                final color = parseColor(m['color'], theme);

                                // Calculate start day based on previous milestone's end
                                final int previousEnd = index == 0
                                    ? 0
                                    : (milestones[index - 1]['day_offset']
                                          as int);
                                final int startDay = previousEnd + 1;
                                final int endDay = m['day_offset'] as int;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 40,
                                        color: color,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              m['phase']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              "DAY $startDay - $endDay",
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // 2. TACTICAL BRIEF (TASK EDITOR)
                          StrategySectionHeader(
                            title: "TACTICAL BRIEF (PREVIEW)",
                          ),
                          // Use the state variable _visibleDayCount to limit the list
                          ...briefing.take(_visibleDayCount).map((dayData) {
                            return StrategyDayEditor(
                              key: ValueKey(dayData['day']),
                              dayData: Map<String, dynamic>.from(dayData),
                              onToggle: (taskId) => widget.onboardingCubit
                                  .modifyTaskToggle(dayData['day'], taskId),
                              onAdd: (content) => widget.onboardingCubit
                                  .addTaskToDay(dayData['day'], content),
                              onDelete: (taskId) => widget.onboardingCubit
                                  .removeTask(dayData['day'], taskId),
                            );
                          }),

                          const SizedBox(height: 16),

                          // Only show "Load More" button if there are hidden days
                          if (_visibleDayCount < briefing.length)
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    // Show all days when clicked
                                    _visibleDayCount = briefing.length;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  "SHOW FULL BRIEFING (+ ${briefing.length - _visibleDayCount} DAYS)",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 48),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAction(
          onConfirm: () => widget.onboardingCubit.confirmStrategy(),
        ),
      ),
    );
  }
}
