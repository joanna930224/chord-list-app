import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/preference_provider.dart';
import 'package:flutter/services.dart';

/// 햅틱 피드백 프로바이더
final hapticProvider = Provider<HapticService>((ref) {
  return HapticService(ref);
});

/// 햅틱 피드백 타입 열거형
enum HapticType { light, medium, heavy, selection, impact }

/// 햅틱 피드백 서비스 클래스
///
/// 사용자의 진동 설정을 확인하고 적절한 햅틱 피드백을 제공합니다.
/// 설정에서 진동을 끄면 햅틱이 실행되지 않습니다.
class HapticService {
  const HapticService(this._ref);

  final Ref _ref;

  /// 가벼운 햅틱 피드백
  ///
  /// 일반적인 버튼 탭, 터치 피드백에 사용
  Future<void> light() async {
    await _executeHaptic(() => HapticFeedback.lightImpact());
  }

  /// 중간 강도 햅틱 피드백
  ///
  /// 중요한 액션이나 상태 변경에 사용
  Future<void> medium() async {
    await _executeHaptic(() => HapticFeedback.mediumImpact());
  }

  /// 강한 햅틱 피드백
  ///
  /// 경고, 에러, 중요한 알림에 사용
  Future<void> heavy() async {
    await _executeHaptic(() => HapticFeedback.heavyImpact());
  }

  /// 선택 햅틱 피드백
  ///
  /// 드롭다운, 피커 등의 선택 변경에 사용
  Future<void> selection() async {
    await _executeHaptic(() => HapticFeedback.selectionClick());
  }

  /// 범용 햅틱 피드백
  ///
  /// HapticType 열거형을 사용하여 다양한 타입 지원
  Future<void> feedback(HapticType type) async {
    switch (type) {
      case HapticType.light:
        await light();
        break;
      case HapticType.medium:
        await medium();
        break;
      case HapticType.heavy:
        await heavy();
        break;
      case HapticType.selection:
        await selection();
        break;
      case HapticType.impact:
        await light(); // impact는 light와 동일하게 처리
        break;
    }
  }

  /// 햅틱 실행 내부 로직
  ///
  /// 햅틱 설정을 확인하고 활성화된 경우에만 햅틱을 실행합니다.
  Future<void> _executeHaptic(VoidCallback hapticCallback) async {
    try {
      // 햅틱 설정 확인
      final isHapticEnabled = await _ref
          .read(preferenceRepositoryProvider)
          .findHaptic();

      // 햅틱이 활성화된 경우에만 햅틱 실행
      if (isHapticEnabled) {
        hapticCallback();
      }
    } catch (e) {
      // 햅틱 실행 실패 시 조용히 무시 (사용자 경험에 영향 없음)
      debugPrint('❌ HapticService: 햅틱 피드백 실행 실패 - $e');
    }
  }
}
