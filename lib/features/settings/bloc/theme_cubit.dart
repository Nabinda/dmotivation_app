import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/settings_service.dart';

class ThemeState {
  final String vibe;
  final bool isDark;

  ThemeState({required this.vibe, required this.isDark});
}

class ThemeCubit extends Cubit<ThemeState> {
  final SettingsService _settingsService;

  ThemeCubit(this._settingsService)
    : super(
        ThemeState(
          vibe: _settingsService.getVibe(),
          isDark: _settingsService.getIsDarkMode(),
        ),
      );

  void toggleBrightness() {
    final newMode = !state.isDark;
    _settingsService.saveIsDarkMode(newMode);
    emit(ThemeState(vibe: state.vibe, isDark: newMode));
  }

  void changeVibe(String newVibe) {
    _settingsService.saveVibe(newVibe);
    emit(ThemeState(vibe: newVibe, isDark: state.isDark));
  }
}
