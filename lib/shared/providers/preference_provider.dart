// ignore_for_file: non_constant_identifier_names

import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = FutureProvider((ref) {
  return SharedPreferences.getInstance();
});

final preferenceRepositoryProvider = Provider.autoDispose((ref) {
  final prefs = ref.watch(sharedPreferencesProvider.future);

  return PreferenceRepository(prefs);
});

class PreferenceRepository {
  const PreferenceRepository(this._instance);

  final Future<SharedPreferences> _instance;

  final _THEME_MODE = 'THEME_MODE';
  final _HAPTIC = 'HAPTIC';

  /// 테마 모드 조회
  Future<AppThemeMode> findThemeMode() async {
    final prefs = await _instance;

    return AppThemeMode.values[prefs.getInt(_THEME_MODE) ?? 0];
  }

  /// 테마 모드 설정
  Future<void> saveThemeMode(AppThemeMode themeMode) async {
    final prefs = await _instance;
    await prefs.setInt(_THEME_MODE, themeMode.index);
  }

  /// 햅틱 모드 조회
  Future<bool> findHaptic() async {
    final prefs = await _instance;
    return prefs.getBool(_HAPTIC) ?? true;
  }

  /// 햅틱 설정
  Future<void> saveHaptic(bool value) async {
    final prefs = await _instance;
    await prefs.setBool(_HAPTIC, value);
  }
}
