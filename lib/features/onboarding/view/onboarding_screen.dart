import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// Logic Imports
import '../bloc/onboarding_cubit.dart';
import '../bloc/onboarding_state.dart';
import '../repo/onboarding_repo.dart';

// Widget Imports
import 'widgets/mission_step.dart';
import 'widgets/protocol_step.dart';
import 'widgets/schedule_step.dart';
import 'widgets/enemy_step.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // INJECTION: Ensure we use the Global Repo, but create a new Cubit for this session
    return BlocProvider(
      create: (context) => OnboardingCubit(context.read<OnboardingRepo>()),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  final _missionFormKey = GlobalKey<FormState>();

  int _currentPage = 0;
  final int _totalPages = 4;

  void _nextPage(BuildContext context, OnboardingState state) {
    FocusScope.of(context).unfocus();

    final cubit = context.read<OnboardingCubit>();

    if (_currentPage == 0) {
      if (!_missionFormKey.currentState!.validate()) return;
      if (state.deadline == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Deadline is mandatory. The clock must start."),
          ),
        );
        return;
      }
    }

    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // NEW LOGIC: Generate Strategy (Goes to Review) instead of Submit (Save)
      cubit.generateStrategy();
    }
  }

  void _prevPage() {
    FocusScope.of(context).unfocus();
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Date Picker Logic
  Future<void> _selectDeadline(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final cubit = context.read<OnboardingCubit>();
    final theme = Theme.of(context);

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: Theme(
            data: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                surface: theme.cardTheme.color,
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) cubit.updateDeadline(picked);
  }

  Future<void> _selectTime(
    BuildContext context,
    bool isWake,
    TimeOfDay current,
  ) async {
    FocusScope.of(context).unfocus();
    final cubit = context.read<OnboardingCubit>();
    final theme = Theme.of(context);

    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              tertiary: theme.colorScheme.primary,
              onTertiary: theme.colorScheme.onPrimary,
              tertiaryContainer: theme.colorScheme.primary,
              onTertiaryContainer: theme.colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isWake) {
        cubit.updateWakeTime(picked);
      } else {
        cubit.updateSleepTime(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state.status == OnboardingStatus.generated) {
          // Navigate using GoRouter and pass the current Cubit as extra
          context.push(
            '/strategy-review',
            extra: context.read<OnboardingCubit>(),
          );
        } else if (state.status == OnboardingStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.errorMessage}"),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: _currentPage > 0
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back, size: 24),
                          onPressed: _prevPage,
                          color: colorScheme.secondary,
                        )
                      : null,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_totalPages, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 40,
                        height: 4,
                        color: index <= _currentPage
                            ? colorScheme.primary
                            : colorScheme.secondary.withValues(alpha: 0.3),
                      );
                    }),
                  ),
                  centerTitle: true,
                ),
              ],
              body: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  SingleChildScrollView(
                    child: MissionStep(
                      formKey: _missionFormKey,
                      onObjectiveChanged: cubit.updateObjective,
                      deadline: state.deadline,
                      onDeadlineTap: () => _selectDeadline(context),
                    ),
                  ),
                  SingleChildScrollView(
                    child: ProtocolStep(
                      intensity: state.intensity,
                      onIntensityChanged: cubit.updateIntensity,
                    ),
                  ),
                  SingleChildScrollView(
                    child: ScheduleStep(
                      wakeTime: state.wakeTime,
                      sleepTime: state.sleepTime,
                      onWakeTimeTap: () =>
                          _selectTime(context, true, state.wakeTime),
                      onSleepTimeTap: () =>
                          _selectTime(context, false, state.sleepTime),
                      selectedPreferences: state.injectionPreferences,
                      onTogglePreference: cubit.toggleInjectionPreference,
                      reviewFrequency: state.reviewFrequency,
                      onFrequencyChanged: cubit.updateReviewFrequency,
                    ),
                  ),
                  SingleChildScrollView(
                    child: EnemyStep(
                      selectedWeaknesses: state.weaknesses,
                      onToggleWeakness: cubit.toggleWeakness,
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _currentPage == _totalPages - 1
                      ? "GENERATE PROTOCOL"
                      : "AWAITING INPUT...",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                    fontSize: 12,
                  ),
                ),
                ElevatedButton(
                  onPressed: state.status == OnboardingStatus.submitting
                      ? null
                      : () => _nextPage(context, state),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: state.status == OnboardingStatus.submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          _currentPage == _totalPages - 1
                              ? "REVIEW STRATEGY"
                              : "NEXT >",
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
