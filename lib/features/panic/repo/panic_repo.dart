class PanicRepository {
  // Simple static data for MVP. Later this could be AI-generated.
  static final Map<String, Map<String, String>> _protocols = {
    'LAZY': {
      'title': 'WAKE UP',
      'body':
          'Comfort is a slow death. The time you waste now is borrowed from your future success.\n\nGet up. Do one thing. Now.',
    },
    'ANXIOUS': {
      'title': 'CONTROL THE CONTROLLABLE',
      'body':
          'Anxiety is creating problems that don\'t exist yet. Look at your hands. Look at the task in front of you.\n\nDo that. Ignore the rest.',
    },
    'BURNOUT': {
      'title': 'REST IS A WEAPON',
      'body':
          'You are not a machine. If the engine creates too much heat, it breaks.\n\nStep away for 15 minutes. Reset. Then attack.',
    },
    'LOST': {
      'title': 'RECALIBRATE',
      'body':
          'Forget the 5-year plan. What is the immediate next step?\n\nJust one step. Execute that.',
    },
    'PROCRASTINATING': {
      'title': 'KILL THE RESISTANCE',
      'body':
          'The longer you wait, the heavier it gets. Count to 5.\n\n1... 2... 3... 4... 5.\n\nGO.',
    },
  };

  Map<String, String> getProtocol(String state) {
    return _protocols[state.toUpperCase()] ??
        {'title': 'STAND TALL', 'body': 'Hold the line.'};
  }
}
