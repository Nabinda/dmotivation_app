import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math'; // For Random

class BoxBreathing extends StatefulWidget {
  const BoxBreathing({super.key});

  @override
  State<BoxBreathing> createState() => _BoxBreathingState();
}

class _BoxBreathingState extends State<BoxBreathing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  String _instruction = "PREPARE";
  String _currentMessage = "";
  Timer? _phaseTimer;
  int _phase =
      0; // 0: Init, 1: Inhale, 2: Hold (Full), 3: Exhale, 4: Hold (Empty)

  // --- MESSAGE POOL (Stoic / Tactical / Grounding) ---
  final List<String> _calmingMessages = [
    "CONTROL THE BREATH.\nCONTROL THE MIND.",
    "CHAOS IS EXTERNAL.\nORDER IS INTERNAL.",
    "THE EMERGENCY IS ONLY IN YOUR HEAD.\nDETACH.",
    "RESET THE SYSTEM.\nLOWER THE HEART RATE.",
    "YOU ARE SAFE.\nYOU ARE IN COMMAND.",
    "SILENCE THE ALARMS.\nFOCUS ON THE SIGNAL.",
    "PANIC SOLVES NOTHING.\nCLARITY SOLVES EVERYTHING.",
    "SLOW IS SMOOTH.\nSMOOTH IS FAST.",
    "THIS FEELING IS TEMPORARY.\nYOUR WILL IS PERMANENT.",
    "RECALIBRATE YOUR SENSORS.\nBREATHE.",
    "DO NOT REACT.\nRESPOND.",
  ];

  @override
  void initState() {
    super.initState();
    _updateMessage(); // Initial message

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // 4 seconds per breath phase
    );

    // Animate from 30% size to 100% size
    _sizeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start sequence after a brief pause
    Future.delayed(const Duration(seconds: 1), _startCycle);
  }

  void _updateMessage() {
    setState(() {
      _currentMessage =
          _calmingMessages[Random().nextInt(_calmingMessages.length)];
    });
  }

  void _startCycle() {
    if (!mounted) return;
    _runPhase();
  }

  void _runPhase() {
    if (!mounted) return;

    // Cycle: 1 -> 2 -> 3 -> 4 -> 1...
    _phase = (_phase % 4) + 1;

    // Rotate the motivational message at the start of every new cycle (Inhale phase)
    if (_phase == 1) {
      _updateMessage();
    }

    setState(() {
      switch (_phase) {
        case 1: // Inhale (4s)
          _instruction = "INHALE";
          _controller.duration = const Duration(seconds: 4);
          _controller.forward();
          break;
        case 2: // Hold Full (4s)
          _instruction = "HOLD";
          // No animation change, keep expanded
          break;
        case 3: // Exhale (4s)
          _instruction = "EXHALE";
          _controller.duration = const Duration(seconds: 4);
          _controller.reverse();
          break;
        case 4: // Hold Empty (4s)
          _instruction = "HOLD";
          // No animation change, keep shrunk
          break;
      }
    });

    // Schedule next phase
    _phaseTimer = Timer(const Duration(seconds: 4), _runPhase);
  }

  @override
  void dispose() {
    _controller.dispose();
    _phaseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    // FIXED: Use onSurface with opacity for better visibility in light mode
    // instead of default secondary which might be too light/washed out.
    final secondaryTextColor = theme.brightness == Brightness.light
        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
        : theme.colorScheme.secondary;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Max box size is 60% of screen width to stay contained
        final maxSize = constraints.maxWidth * 0.6;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "TACTICAL BREATHING",
                style: theme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 2.0,
                  color: secondaryTextColor, // Applied fix here
                ),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: maxSize,
                height: maxSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. Static Outer Border (Ghost Box)
                    Container(
                      width: maxSize,
                      height: maxSize,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primary.withValues(alpha: 0.1),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    // 2. Animated Inner Box
                    AnimatedBuilder(
                      animation: _sizeAnimation,
                      builder: (context, child) {
                        final currentSize = maxSize * _sizeAnimation.value;
                        // Don't let it disappear completely (min size 60px)
                        final displaySize = currentSize < 60.0
                            ? 60.0
                            : currentSize;

                        return Container(
                          width: displaySize,
                          height: displaySize,
                          decoration: BoxDecoration(
                            border: Border.all(color: primary, width: 2),
                            borderRadius: BorderRadius.circular(12),
                            color: primary.withValues(alpha: 0.1),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.2),
                                blurRadius:
                                    20 +
                                    (10 * _sizeAnimation.value), // Pulse glow
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: _sizeAnimation.value > 0.4
                                ? Text(
                                    _instruction,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                  )
                                : null, // Hide text when too small
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Instructions / Dynamic Message
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _currentMessage,
                  key: ValueKey(_currentMessage),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        onSurface, // Use onSurface for better visibility in light/dark modes
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
