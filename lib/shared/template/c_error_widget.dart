import 'package:chord_list_app/shared/exports.dart';

class CErrorWidget extends HookWidget {
  const CErrorWidget({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.error, size: 30, color: context.colorScheme.error),
    );
  }
}
