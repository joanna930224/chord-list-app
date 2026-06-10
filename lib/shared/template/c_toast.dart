import 'package:chord_list_app/shared/exports.dart';

/// 공통 토스트 메시지
///
/// [ScaffoldMessenger]를 통해 하단에 잠깐 표시되는 메시지.
class CToast {
  CToast._();

  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: context.textTheme.regular14.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: context.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }
}
