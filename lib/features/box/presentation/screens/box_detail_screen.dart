import 'package:chord_list_app/features/box/application/box_detail_state.dart';
import 'package:chord_list_app/features/box/application/box_detail_view_model_provider.dart';
import 'package:chord_list_app/features/box/presentation/widgets/box_edit_dialog.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/database_provider.dart';
import 'package:chord_list_app/shared/template/c_dialog.dart';
import 'package:chord_list_app/shared/template/c_scaffold.dart';
import 'package:chord_list_app/shared/template/c_toast.dart';
import 'package:chord_list_app/shared/template/future_value_widget.dart';
import 'package:chord_list_app/shared/widgets/chord_position_card_widget.dart';
import 'package:intl/intl.dart';

class BoxDetailScreen extends HookConsumerWidget {
  static String get routeName => '5f521d4b-5fa2-480d-8d43-d1726b013ba3';

  const BoxDetailScreen({super.key, required this.boxId});

  final int boxId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureValueWidget(
      ref.watch(boxDetailViewModelProvider(boxId).future),
      data: (data) {
        final BoxDetailState(box: box, chordDetails: chordDetails) = data;
        final dateStr = DateFormat('yyyy. M. d').format(box.createdAt);

        Future<void> onEditTap() async {
          await showDialog<void>(
            context: context,
            builder: (_) => BoxEditDialog(
              box: box,
              onSuccess: () {
                context.pop();
                ref
                    .read(boxDetailViewModelProvider(boxId).notifier)
                    .refreshBox();
              },
              onError: () => CToast.show(context, '오류가 발생하였습니다.'),
            ),
          );
        }

        Future<void> onDeleteTap() async {
          final confirmed = await showCDialog<bool>(
            context: context,
            title: '해당 Box를 삭제하시겠습니까?',
            actions: [
              const CDialogAction(text: '아니오', result: false),
              const CDialogAction(text: '예', result: true, isPrimary: true),
            ],
          );
          if (confirmed != true || !context.mounted) return;
          try {
            final db = ref.read(appDatabaseProvider);
            await db.boxDao.deleteById(boxId);
            if (context.mounted) context.pop();
          } catch (_) {
            if (context.mounted) CToast.show(context, '오류가 발생하였습니다.');
          }
        }

        return CScaffold(
          title: Text(box.title, style: context.textTheme.semiBold16),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') onEditTap();
                if (value == 'delete') onDeleteTap();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('수정')),
                PopupMenuItem(value: 'delete', child: Text('삭제')),
              ],
            ),
          ],
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (box.description != null &&
                        box.description!.isNotEmpty) ...[
                      Text(
                        box.description!,
                        style: context.textTheme.regular14.copyWith(
                          color: context.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      dateStr,
                      style: context.textTheme.regular12.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                  ],
                ).ph20,
              ),
              if (chordDetails.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('저장된 코드가 없습니다.')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.orientationOf(context) ==
                              Orientation.landscape
                          ? 4
                          : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final detail = chordDetails[index];
                        return ChordPositionCardWidget(
                          chord: detail.chord,
                          position: detail.position,
                          onTap: () {},
                        );
                      },
                      childCount: chordDetails.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
