import 'package:chord_list_app/shared/exports.dart';

/// 공통 바텀시트
///
/// 드래그 핸들, 상단 둥근 모서리 스타일이 기본 적용된다.
/// [builder]로 내부 콘텐츠를 주입한다.
Future<T?> showCBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: builder,
  );
}

/// 바텀시트 상단 드래그 핸들
class CBottomSheetHandle extends StatelessWidget {
  const CBottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: context.colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
