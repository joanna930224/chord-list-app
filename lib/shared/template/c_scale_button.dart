import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/haptic_provider.dart';

/// 클릭 시 확장+햅틱 피드백 적용
class CScaleButton extends HookConsumerWidget {
  const CScaleButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleValue = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
    this.hapticType = HapticType.light,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleValue;
  final Duration duration;
  final Curve curve;
  final HapticType hapticType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(duration: duration);
    final hapticService = ref.read(hapticProvider);

    final scaleAnimation = useMemoized(
      () => Tween<double>(
        begin: 1.0,
        end: scaleValue,
      ).animate(CurvedAnimation(parent: animationController, curve: curve)),
      [animationController, scaleValue, curve],
    );

    void safeForward() {
      try {
        // mounted 체크는 Hook에서 자동 처리되므로 기본 상태만 확인
        if (animationController.status == AnimationStatus.dismissed ||
            animationController.status == AnimationStatus.reverse) {
          animationController.forward();
        }
      } catch (e) {
        // dispose된 컨트롤러 접근 시 에러 무시
      }
    }

    void safeReverse() {
      try {
        // forward나 completed 상태에서만 reverse 실행
        if (animationController.status == AnimationStatus.forward ||
            animationController.status == AnimationStatus.completed) {
          animationController.reverse();
        }
      } catch (e) {
        // dispose된 컨트롤러 접근 시 에러 무시
      }
    }

    return Listener(
      onPointerDown: (_) {
        try {
          hapticService.feedback(hapticType);
        } catch (e) {
          // 햅틱 에러는 무시 (UX에 영향 없음)
        }
        safeForward();
      },
      onPointerUp: (_) {
        safeReverse();
      },
      onPointerCancel: (_) {
        safeReverse();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedBuilder(
          animation: scaleAnimation,
          child: child,
          builder: (context, cachedChild) {
            return Transform.scale(
              scale: scaleAnimation.value,
              child: cachedChild,
            );
          },
        ),
      ),
    );
  }
}
