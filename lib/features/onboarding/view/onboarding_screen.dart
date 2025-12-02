import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget Imports
import 'widgets/mission_step.dart';
import 'widgets/protocol_step.dart';
import 'widgets/schedule_step.dart';
import 'widgets/enemy_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final _missionFormKey = GlobalKey<FormState>();

  int _currentPage = 0;
  final int _totalPages = 4;

  // Form Data
  String _objective = '';
  DateTime? _deadline;
  String _intensity = 'High';
  final List<String> _selectedWeaknesses = [];
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _sleepTime = const TimeOfDay(hour: 23, minute: 0);

  // Navigation Logic
  void _nextPage() {
    // Phase 1 Validation
    if (_currentPage == 0) {
      if (!_missionFormKey.currentState!.validate()) return;
      if (_deadline == null) {
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
      print("Onboarding Complete: $_objective, $_intensity");
      context.go('/home');
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Date Picker Logic (Moved here to keep widgets stateless)
  Future<void> _selectDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        // Fix for TextScaler crash in DatePicker
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                surface: Theme.of(context).cardTheme.color,
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _selectTime(bool isWake) async {
    final initial = isWake ? _wakeTime : _sleepTime;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        if (isWake)
          _wakeTime = picked;
        else
          _sleepTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
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
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) => setState(() => _currentPage = page),
        children: [
          MissionStep(
            formKey: _missionFormKey,
            onObjectiveChanged: (val) => _objective = val,
            deadline: _deadline,
            onDeadlineTap: _selectDeadline,
          ),
          ProtocolStep(
            intensity: _intensity,
            onIntensityChanged: (val) => setState(() => _intensity = val),
          ),
          ScheduleStep(
            wakeTime: _wakeTime,
            sleepTime: _sleepTime,
            onWakeTimeTap: () => _selectTime(true),
            onSleepTimeTap: () => _selectTime(false),
          ),
          EnemyStep(
            selectedWeaknesses: _selectedWeaknesses,
            onToggleWeakness: (enemy) {
              setState(() {
                _selectedWeaknesses.contains(enemy)
                    ? _selectedWeaknesses.remove(enemy)
                    : _selectedWeaknesses.add(enemy);
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          // Updated: Use withValues instead of withOpacity
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
                  ? "INITIALIZE PROTOCOL"
                  : "AWAITING INPUT...",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                fontSize: 12,
              ),
            ),
            ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(
                _currentPage == _totalPages - 1 ? "SIGN CONTRACT" : "NEXT >",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
