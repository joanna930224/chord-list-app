import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_elevated_button.dart';

/// 공통 다이얼로그 액션 버튼 정의
///
/// [result]를 지정하면 해당 버튼 탭 시 [showCDialog]의 반환값으로 전달된다.
/// [isPrimary]가 true이면 강조 버튼(브랜드 컬러), false이면 보조 버튼으로 렌더링된다.
class CDialogAction<T> {
  const CDialogAction({
    required this.text,
    this.result,
    this.isPrimary = false,
  });

  final String text;
  final T? result;
  final bool isPrimary;
}

/// 공통 다이얼로그
///
/// 제목 + 선택적 메시지 + 버튼 목록으로 구성된 간단한 확인/알림 다이얼로그.
/// 버튼 탭 시 해당 [CDialogAction.result] 값을 반환한다.
/// 폼 입력이 필요한 경우 [showDialog]와 별도 위젯을 사용한다.
Future<T?> showCDialog<T>({
  required BuildContext context,
  required String title,
  String? message,
  required List<CDialogAction<T>> actions,
}) {
  return showDialog<T>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: context.textTheme.semiBold16),
      content: message != null
          ? Text(message, style: context.textTheme.regular14)
          : null,
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            for (int i = 0; i < actions.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              SizedBox(
                width: 86,
                child: CElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(actions[i].result),
                  title: actions[i].text,
                  height: 40,
                  borderRadius: 40,
                  backgroundColor: actions[i].isPrimary
                      ? null
                      : context.colorScheme.secondaryContainer,
                  textColor: actions[i].isPrimary
                      ? Colors.white
                      : context.colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ],
        ),
      ],
    ),
  );
}
