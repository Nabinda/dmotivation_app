import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math'; // For Random

class ActionTimer extends StatefulWidget {
  const ActionTimer({super.key});

  @override
  State<ActionTimer> createState() => _ActionTimerState();
}

class _ActionTimerState extends State<ActionTimer> {
  static const int _startSeconds = 300; // 5 Minutes
  int _currentSeconds = _startSeconds;
  Timer? _timer;
  bool _isRunning = false;
  String _currentMessage = "";

  // --- MESSAGE POOLS ---
  final List<String> _initialMessages = [
    "Comfort is a slow death.\n5 minutes of pain. Prove you are not average.",
    "Procrastination is the grave of opportunity.\nPick up the shovel.",
    "You said you wanted it.\nProve it.",
    "The clock is ticking on your potential.\nDon't let it run out.",
    "Nobody is coming to save you.\nIt starts with you.",
    "Feelings are irrelevant.\nAction is everything.",
    "You are one decision away from a different life.\nMake the right one.",
    "Stop negotiating with yourself.\nThe contract is signed.",
    "Average people quit here.\nAre you average?",
    "The resistance is strong.\nYou must be stronger.",
    "Do not wait for motivation.\nIt is a lie. Discipline is real.",
  ];

  final List<String> _runningMessages = [
    "GOOD. STAY IN THE FIGHT.\nDO NOT LET THE NOISE IN.",
    "PAIN IS WEAKNESS LEAVING THE BODY.\nKEEP GOING.",
    "THEY WANT YOU TO FAIL.\nDISAPPOINT THEM.",
    "ONE FOOT IN FRONT OF THE OTHER.\nDO NOT STOP.",
    "THIS IS WHERE GROWTH HAPPENS.\nEMBRACE THE SUCK.",
    "MOMENTUM IS BUILDING.\nDO NOT BREAK THE CHAIN.",
    "FOCUS ON THE NEXT SECOND.\nNOTHING ELSE MATTERS.",
    "YOU ARE REWRITING YOUR DNA.\nEVERY SECOND COUNTS.",
    "SILENCE THE VOICE THAT WANTS TO QUIT.\nIT IS LYING.",
    "THIS IS THE PRICE OF GREATNESS.\nPAY IT GLADLY.",
    "DO NOT LOOK AT THE CLOCK.\nLOOK AT THE WORK.",
  ];

  final List<String> _pausedMessages = [
    "WHY DID YOU STOP?\nPAIN IS TEMPORARY. QUITTING LASTS FOREVER.",
    "IS THIS YOUR LIMIT?\nGET BACK IN THE ARENA.",
    "EXCUSES BUILD MONUMENTS TO NOTHING.\nRE-ENGAGE.",
    "TIRED? GOOD.\nTHAT MEANS IT'S WORKING.",
    "YOU ARE BETTER THAN THIS.\nPROVE IT.",
    "DID YOU COME THIS FAR JUST TO COME THIS FAR?\nRESTART.",
    "YOUR FUTURE SELF IS WATCHING.\nDO NOT DISAPPOINT THEM.",
    "FAILURE IS A CHOICE.\nCHOOSE DIFFERENTLY.",
    "THE WORLD DOES NOT PAUSE FOR YOU.\nGET MOVING.",
    "WEAKNESS IS TRYING TO WIN.\nCRUSH IT.",
    "DO NOT LET COMFORT WIN.\nSTAND UP.",
  ];

  @override
  void initState() {
    super.initState();
    _updateMessage(); // Set initial random message
  }

  void _updateMessage() {
    final random = Random();
    if (_currentSeconds == _startSeconds) {
      _currentMessage =
          _initialMessages[random.nextInt(_initialMessages.length)];
    } else if (_isRunning) {
      _currentMessage =
          _runningMessages[random.nextInt(_runningMessages.length)];
    } else {
      _currentMessage = _pausedMessages[random.nextInt(_pausedMessages.length)];
    }
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentSeconds > 0) {
          setState(() => _currentSeconds--);
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            _updateMessage();
          });
        }
      });
    }

    setState(() {
      _isRunning = !_isRunning;
      _updateMessage();
    });
  }

  String get _formattedTime {
    final minutes = (_currentSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_currentSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // FIXED: Use Primary color so it matches the selected Vibe (Green/Orange/Blue)
    final color = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = theme.brightness == Brightness.light
        ? theme.colorScheme.onSurface.withValues(alpha: 0.8)
        : theme.colorScheme.secondary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon visual
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.bolt, size: 40, color: color),
          ),

          const SizedBox(height: 32),

          Text(
            "STOP BEING WEAK",
            style: theme.textTheme.labelLarge?.copyWith(
              letterSpacing: 2.0,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 48),

          // Digital Clock Display
          Text(
            _formattedTime,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 96,
              color: color,
              fontWeight: FontWeight.w900,
              fontFeatures: [const FontFeature.tabularFigures()],
              letterSpacing: -4.0,
            ),
          ),

          const SizedBox(height: 16),

          // Dynamic Status Message (Randomized)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _currentMessage,
              key: ValueKey(_currentMessage),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                // Use primary for "running" state to emphasize action
                color: _isRunning ? color : secondaryTextColor,
                height: 1.5,
                fontWeight: _isRunning ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),

          const SizedBox(height: 64),

          // Action Button
          SizedBox(
            width: 280,
            height: 56,
            child: ElevatedButton(
              onPressed: _toggleTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: theme
                    .colorScheme
                    .onPrimary, // Ensure text is visible on primary
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                elevation: 8,
                shadowColor: color.withValues(alpha: 0.5),
              ),
              child: Text(
                _isRunning
                    ? "I AM QUITTING"
                    : (_currentSeconds < _startSeconds && _currentSeconds > 0
                          ? "RE-ENGAGE NOW"
                          : "EXECUTE PROTOCOL"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
