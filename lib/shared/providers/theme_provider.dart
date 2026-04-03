import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/preference_provider.dart';

enum AppThemeMode { system, light, dark }

final themeProvider = AsyncNotifierProvider<ThemeNotifier, AppThemeMode>(
  () => ThemeNotifier(),
);

class ThemeNotifier extends AsyncNotifier<AppThemeMode> {
  @override
  Future<AppThemeMode> build() async {
    final prefs = ref.read(preferenceRepositoryProvider);
    final themeMode = await prefs.findThemeMode();

    return themeMode;
  }

  Future<void> setLight() async {
    state = const AsyncData(AppThemeMode.light);
    await _saveThemeMode(AppThemeMode.light);
  }

  Future<void> setDark() async {
    state = const AsyncData(AppThemeMode.dark);
    await _saveThemeMode(AppThemeMode.dark);
  }

  Future<void> setSystem() async {
    state = const AsyncData(AppThemeMode.system);
    await _saveThemeMode(AppThemeMode.system);
  }

  Future<void> toggle() async {
    final currentMode = state.value ?? AppThemeMode.system;
    final newMode = switch (currentMode) {
      AppThemeMode.light => AppThemeMode.dark,
      AppThemeMode.dark => AppThemeMode.system,
      AppThemeMode.system => AppThemeMode.light,
    };

    state = AsyncData(newMode);
    await _saveThemeMode(newMode);
  }

  Future<void> _saveThemeMode(AppThemeMode themeMode) async {
    final prefs = ref.read(preferenceRepositoryProvider);
    await prefs.saveThemeMode(themeMode);
  }

  ThemeMode get themeMode {
    final currentMode = state.value ?? AppThemeMode.system;
    return switch (currentMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }

  IconData get themeIcon {
    final currentMode = state.value ?? AppThemeMode.system;
    return switch (currentMode) {
      AppThemeMode.light => Icons.light_mode,
      AppThemeMode.dark => Icons.dark_mode,
      AppThemeMode.system => Icons.brightness_6,
    };
  }
}
