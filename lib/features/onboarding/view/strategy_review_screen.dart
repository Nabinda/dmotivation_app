import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/onboarding_cubit.dart';
import '../bloc/onboarding_state.dart';

class StrategyReviewScreen extends StatefulWidget {
  final OnboardingCubit onboardingCubit;

  const StrategyReviewScreen({super.key, required this.onboardingCubit});

  @override
  State<StrategyReviewScreen> createState() => _StrategyReviewScreenState();
}

class _StrategyReviewScreenState extends State<StrategyReviewScreen> {
  // We use a ScrollController to strictly maintain the scroll offset.
  // The CustomScrollView will attach to this controller and stay persistent.
  final ScrollController _scrollController = ScrollController();

  // State to track how many days are currently visible in the briefing list
  int _visibleDayCount = 3;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        // FIX: The CustomScrollView is now the persistent parent.
        // It does NOT rebuild when the state changes.
        body: BlocListener<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state.status == OnboardingStatus.success) {
              context.go('/home'); // Go to Dashboard after confirmation
            }
          },
          child: CustomScrollView(
            controller: _scrollController,
            // PageStorageKey helps persist scroll position even if widget is recreated (e.g. tab switch)
            key: const PageStorageKey('strategy_review_scroll'),
            slivers: [
              // The BlocBuilder is inside a SliverToBoxAdapter.
              // This ensures only the CONTENT rebuilds, not the ScrollView.
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
                          _SectionHeader(title: "OPERATIONAL TIMELINE"),
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
                                final color = _parseColor(m['color'], theme);

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
                          _SectionHeader(title: "TACTICAL BRIEF (PREVIEW)"),
                          // Use the state variable _visibleDayCount to limit the list
                          ...briefing.take(_visibleDayCount).map((dayData) {
                            return _DayEditor(
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
        bottomNavigationBar: _BottomAction(
          onConfirm: () => widget.onboardingCubit.confirmStrategy(),
        ),
      ),
    );
  }

  Color _parseColor(String? colorName, ThemeData theme) {
    final isLight = theme.brightness == Brightness.light;

    switch (colorName?.toLowerCase()) {
      case 'green':
        return isLight ? const Color(0xFF008945) : const Color(0xFF00FF94);
      case 'orange':
        return isLight ? const Color(0xFFD84315) : const Color(0xFFFF4500);
      case 'red':
        return isLight ? const Color(0xFFD32F2F) : const Color(0xFFFF3B30);
      case 'blue':
        return isLight ? const Color(0xFF0277BD) : const Color(0xFF38BDF8);
      default:
        return theme.colorScheme.primary;
    }
  }
}

class _DayEditor extends StatelessWidget {
  final Map<String, dynamic> dayData;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onDelete;

  const _DayEditor({
    super.key,
    required this.dayData,
    required this.onToggle,
    required this.onAdd,
    required this.onDelete,
  });

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ADD TASK"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter task details"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onAdd(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text("ADD"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tasks = List<Map<String, dynamic>>.from(dayData['tasks']);
    final dayLabel = "DAY ${dayData['day'].toString().padLeft(2, '0')}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: () => _showAddDialog(context),
                tooltip: "Add Task",
              ),
            ],
          ),
          const Divider(),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "No tasks.",
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
            ),
          ...tasks.map((task) {
            final isDone = task['is_completed'] == true;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Checkbox(
                value: isDone,
                onChanged: (_) => onToggle(task['id']),
                activeColor: theme.colorScheme.secondary,
              ),
              title: Text(
                task['content'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDone
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.onSurface,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 16,
                  color: theme.colorScheme.error.withValues(alpha: 0.5),
                ),
                onPressed: () => onDelete(task['id']),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.secondary,
          letterSpacing: 2.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final VoidCallback onConfirm;
  const _BottomAction({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: onConfirm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: Text(
          "CONFIRM & SIGN CONTRACT",
          style: GoogleFonts.jetBrainsMono(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
