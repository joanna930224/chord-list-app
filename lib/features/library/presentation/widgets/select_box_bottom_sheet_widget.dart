import 'package:chord_list_app/features/box/application/box_view_model_provider.dart';
import 'package:chord_list_app/features/box/domain/models/chord_box_model.dart';
import 'package:chord_list_app/features/box/presentation/widgets/box_empty_widget.dart';
import 'package:chord_list_app/features/box/presentation/widgets/box_list_tile_widget.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/database_provider.dart';
import 'package:chord_list_app/shared/template/c_bottom_sheet.dart';
import 'package:chord_list_app/shared/template/c_dialog.dart';
import 'package:chord_list_app/shared/template/c_elevated_button.dart';

class SelectBoxBottomSheetWidget extends HookConsumerWidget {
  const SelectBoxBottomSheetWidget({
    super.key,
    required this.chordPositionId,
    required this.onSuccess,
    required this.onError,
    this.onCreateNew,
  });

  final int chordPositionId;
  final void Function(String boxTitle) onSuccess;
  final VoidCallback onError;
  final VoidCallback? onCreateNew;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxState = ref.watch(boxViewModelProvider);

    Future<void> handleBoxTap(ChordBoxModel box) async {
      final db = ref.read(appDatabaseProvider);

      final isDuplicate = await db.boxChordDao.existsInBox(
        box.id,
        chordPositionId,
      );
      if (!context.mounted) return;

      if (isDuplicate) {
        final confirmed = await showCDialog<bool>(
          context: context,
          title: '중복 저장',
          message: '이미 저장된 코드입니다.\n중복 추가 하시겠습니까?',
          actions: [
            CDialogAction(text: '아니오', result: false),
            CDialogAction(text: '예', result: true, isPrimary: true),
          ],
        );
        if (!context.mounted || confirmed != true) return;
      }

      try {
        await db.boxChordDao.insertBoxChord(box.id, chordPositionId);
        if (!context.mounted) return;
        context.pop();
        onSuccess(box.title);
      } catch (_) {
        if (context.mounted) onError();
      }
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CBottomSheetHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text('기존 Box에 추가', style: context.textTheme.semiBold16),
          ),
          const Divider(height: 1),
          boxState.when(
            data: (state) {
              if (state.boxes.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BoxEmptyWidget(),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 150,
                          child: CElevatedButton(
                            onPressed: () {
                              context.pop();
                              onCreateNew?.call();
                            },
                            title: '+ Box 생성하기',
                            height: 40,
                            borderRadius: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.boxes.length,
                  itemBuilder: (_, index) {
                    final box = state.boxes[index];
                    return BoxListTileWidget(
                      box: box,
                      onTap: () => handleBoxTap(box),
                    );
                  },
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, st) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text('목록을 불러올 수 없습니다.')),
            ),
          ),
        ],
      ),
    );
  }
}
