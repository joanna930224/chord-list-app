import 'package:chord_list_app/shared/exports.dart';

class BoxEmptyWidget extends StatelessWidget {
  const BoxEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: context.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Box가 비어있어요.\nBox에 기타 코드들을 담아보세요.',
            textAlign: TextAlign.center,
            style: context.textTheme.regular14.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
