// ignore_for_file: non_constant_identifier_names

import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';
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
  final _NOTATION_STYLE = 'NOTATION_STYLE';
  final _ONBOARDING_DONE = 'ONBOARDING_DONE';
  final _BOX_DETAIL_GUIDE_DONE = 'BOX_DETAIL_GUIDE_DONE';

  /// 테마 모드 조회
  Future<AppThemeMode> findThemeMode() async {
    final prefs = await _instance;

    return AppThemeMode.values[prefs.getInt(_THEME_MODE) ?? 2];
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

  /// 코드 표기 스타일 조회
  Future<ChordNotationStyle> findNotationStyle() async {
    final prefs = await _instance;
    return ChordNotationStyle.values[prefs.getInt(_NOTATION_STYLE) ?? 0];
  }

  /// 코드 표기 스타일 저장
  Future<void> saveNotationStyle(ChordNotationStyle style) async {
    final prefs = await _instance;
    await prefs.setInt(_NOTATION_STYLE, style.index);
  }

  /// 온보딩 완료 여부 조회
  Future<bool> findOnboardingDone() async {
    final prefs = await _instance;
    return prefs.getBool(_ONBOARDING_DONE) ?? false;
  }

  /// 온보딩 완료 처리
  Future<void> saveOnboardingDone() async {
    final prefs = await _instance;
    await prefs.setBool(_ONBOARDING_DONE, true);
  }

  /// Box Detail 코치마크 노출 완료 여부 조회
  Future<bool> findBoxDetailGuideDone() async {
    final prefs = await _instance;
    return prefs.getBool(_BOX_DETAIL_GUIDE_DONE) ?? false;
  }

  /// Box Detail 코치마크 다시 보지 않기 처리
  Future<void> saveBoxDetailGuideDone() async {
    final prefs = await _instance;
    await prefs.setBool(_BOX_DETAIL_GUIDE_DONE, true);
  }
}
