import 'package:chord_list_app/shared/exports.dart';

class BoxDetailCoachMarkWidget extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  const BoxDetailCoachMarkWidget({
    super.key,
    required this.onConfirm,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.8),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/coach_marks.webp',
                width: constraints.maxWidth * 0.8,
                height: constraints.maxHeight * 0.45,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                '💡 Tip : 코드를 꾹 누르면 편집 모드에서\n순서를 변경하거나 제거할 수 있어요!',
                style: context.textTheme.regular18.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                children: [
                  TextButton(
                    onPressed: onDismiss,
                    child: Text(
                      '☑️ 다시 보지 않기',
                      style: context.textTheme.bold16.copyWith(
                        color: AppColors.grey200,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onConfirm,
                    child: Text(
                      '닫기',
                      style: context.textTheme.bold16.copyWith(
                        color: AppColors.grey200,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ).ph20,
        ),
      ),
    );
  }
}
