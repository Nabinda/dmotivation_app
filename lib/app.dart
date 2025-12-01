import 'package:flutter/material.dart';
import 'theme/theme.dart';

class DMotivationDemoApp extends StatefulWidget {
  const DMotivationDemoApp({super.key});

  @override
  State<DMotivationDemoApp> createState() => _DMotivationDemoAppState();
}

class _DMotivationDemoAppState extends State<DMotivationDemoApp> {
  // State to manage current theme selection
  String _selectedVibe = 'Terminal Velocity';
  Brightness _brightness = Brightness.dark;

  // Helper to get the correct ThemeData based on state
  ThemeData get _currentTheme {
    switch (_selectedVibe) {
      case 'Defcon 1':
        return _brightness == Brightness.dark
            ? AppTheme.defcon1Dark
            : AppTheme.defcon1Light;
      case 'Cold Truth':
        return _brightness == Brightness.dark
            ? AppTheme.coldTruthDark
            : AppTheme.coldTruthLight;
      case 'Terminal Velocity':
      default:
        return _brightness == Brightness.dark
            ? AppTheme.terminalVelocityDark
            : AppTheme.terminalVelocityLight;
    }
  }

  void _toggleBrightness() {
    setState(() {
      _brightness = _brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark;
    });
  }

  void _changeVibe(String newVibe) {
    setState(() {
      _selectedVibe = newVibe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'D/MOTIVATION Theme Demo',
      theme: _currentTheme,
      home: ThemeShowcaseScreen(
        currentVibe: _selectedVibe,
        currentBrightness: _brightness,
        onVibeChanged: _changeVibe,
        onBrightnessToggled: _toggleBrightness,
      ),
    );
  }
}

class ThemeShowcaseScreen extends StatelessWidget {
  final String currentVibe;
  final Brightness currentBrightness;
  final ValueChanged<String> onVibeChanged;
  final VoidCallback onBrightnessToggled;

  const ThemeShowcaseScreen({
    super.key,
    required this.currentVibe,
    required this.currentBrightness,
    required this.onVibeChanged,
    required this.onBrightnessToggled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = currentBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('D/MOTIVATION'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onBrightnessToggled,
            tooltip: 'Toggle Brightness',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // -------------------------------------------------------------------
          // 1. THEME CONTROLS
          // -------------------------------------------------------------------
          Card(
            margin: const EdgeInsets.only(bottom: 32),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECT VIBE',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _VibeButton(
                        label: 'Terminal Velocity',
                        isSelected: currentVibe == 'Terminal Velocity',
                        onTap: () => onVibeChanged('Terminal Velocity'),
                      ),
                      _VibeButton(
                        label: 'Defcon 1',
                        isSelected: currentVibe == 'Defcon 1',
                        onTap: () => onVibeChanged('Defcon 1'),
                      ),
                      _VibeButton(
                        label: 'Cold Truth',
                        isSelected: currentVibe == 'Cold Truth',
                        onTap: () => onVibeChanged('Cold Truth'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // 2. TYPOGRAPHY SHOWCASE
          // -------------------------------------------------------------------
          _SectionHeader(title: 'TYPOGRAPHY'),
          Text('DISPLAY LARGE', style: theme.textTheme.displayLarge),
          const SizedBox(height: 8),
          Text('DISPLAY MEDIUM', style: theme.textTheme.displayMedium),
          const SizedBox(height: 16),
          Text(
            'Body Large: The quick brown fox jumps over the lazy dog. Deconstruct your excuses.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Body Medium: Secondary text information. System status normal. Protocol active.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // -------------------------------------------------------------------
          // 3. COMPONENT SHOWCASE
          // -------------------------------------------------------------------
          _SectionHeader(title: 'COMPONENTS'),

          // Buttons
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('PRIMARY ACTION'),
              ),
              ElevatedButton(
                onPressed: null, // Disabled state
                child: const Text('DISABLED'),
              ),
              FloatingActionButton(
                onPressed: () {},
                mini: true,
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Inputs & Selection
          const TextField(
            decoration: InputDecoration(
              labelText: 'Target Objective',
              hintText: 'e.g., Launch SaaS',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(value: true, onChanged: (v) {}),
              const Text('Daily Protocol Active'),
              const SizedBox(width: 24),
              Checkbox(value: false, onChanged: (v) {}),
              const Text('Pending Task'),
            ],
          ),
          const SizedBox(height: 24),

          // -------------------------------------------------------------------
          // 4. CARDS & SURFACES
          // -------------------------------------------------------------------
          _SectionHeader(title: 'SURFACES'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PHASE 2: THE GRIND',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Icon(Icons.timer, color: theme.colorScheme.secondary),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '45 DAYS REMAINING',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Intensity level is set to Extreme. Maintain operational cadence.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Error / Alert State
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withOpacity(0.1),
              border: Border.all(color: theme.colorScheme.error),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: theme.colorScheme.error),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'CRITICAL FAILURE: Protocol missed 2 days in a row.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: theme.colorScheme.secondary),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.secondary,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _VibeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VibeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(4), // Matching basic shape
        ),
        child: Text(
          label.toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
