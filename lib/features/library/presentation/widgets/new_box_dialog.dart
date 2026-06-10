import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/database_provider.dart';
import 'package:chord_list_app/shared/template/c_elevated_button.dart';
import 'package:drift/drift.dart' show Value;

class NewBoxDialog extends HookConsumerWidget {
  const NewBoxDialog({
    super.key,
    required this.chordPositionId,
    required this.onSuccess,
    required this.onError,
  });

  final int chordPositionId;
  final void Function(String boxTitle) onSuccess;
  final VoidCallback onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final descController = useTextEditingController();
    final titleText = useState('');
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
        final boxId = await db.boxDao.insertBox(
          ChordBoxesCompanion.insert(
            title: title,
            description: Value(desc.isEmpty ? null : desc),
            createdAt: DateTime.now(),
          ),
        );
        await db.boxChordDao.insertBoxChord(boxId, chordPositionId);
        onSuccess(title);
      } catch (_) {
        isLoading.value = false;
        onError();
      }
    }

    final canConfirm = titleText.value.trim().isNotEmpty && !isLoading.value;

    return AlertDialog(
      title: Text('새로운 Box', style: context.textTheme.semiBold16),
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
                title: '만들기',
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
