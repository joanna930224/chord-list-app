import 'package:chord_list_app/features/box/domain/models/chord_box_model.dart';
import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/database_provider.dart';
import 'package:chord_list_app/shared/template/c_elevated_button.dart';
import 'package:drift/drift.dart' show Value;

class BoxEditDialog extends HookConsumerWidget {
  const BoxEditDialog({
    super.key,
    required this.box,
    required this.onSuccess,
    required this.onError,
  });

  final ChordBoxModel box;
  final VoidCallback onSuccess;
  final VoidCallback onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: box.title);
    final descController = useTextEditingController(
      text: box.description ?? '',
    );
    final titleText = useState(box.title);
    final isLoading = useState(false);

    useEffect(() {
      void listener() => titleText.value = titleController.text;
      titleController.addListener(listener);
      return () => titleController.removeListener(listener);
    }, [titleController]);

    Future<void> onConfirm() async {
      isLoading.value = true;
      final db = ref.read(appDatabaseProvider);
      final title = titleController.text.trim();
      final desc = descController.text.trim();
      try {
        await db.boxDao.updateBox(
          box.id,
          ChordBoxesCompanion(
            title: Value(title),
            description: Value(desc.isEmpty ? null : desc),
          ),
        );
        onSuccess();
      } catch (_) {
        isLoading.value = false;
        onError();
      }
    }

    final canConfirm = titleText.value.trim().isNotEmpty && !isLoading.value;

    return AlertDialog(
      title: Text('Box 수정', style: context.textTheme.semiBold16),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                counterText: '',
              ),
              maxLength: 50,
              textInputAction: TextInputAction.next,
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: '설명',
                counterText: '',
              ),
              maxLength: 100,
              enabled: !isLoading.value,
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 86,
              child: CElevatedButton(
                onPressed: isLoading.value ? null : () => context.pop(),
                title: '취소',
                height: 40,
                borderRadius: 40,
                backgroundColor: context.colorScheme.secondaryContainer,
                textColor: context.colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 86,
              child: CElevatedButton(
                onPressed: canConfirm ? onConfirm : null,
                title: '저장',
                enabled: canConfirm,
                height: 40,
                borderRadius: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
