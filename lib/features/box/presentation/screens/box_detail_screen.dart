import 'dart:math' show pi;

import 'package:chord_list_app/features/box/application/box_detail_state.dart';
import 'package:chord_list_app/features/box/application/box_detail_view_model_provider.dart';
import 'package:chord_list_app/features/box/presentation/widgets/box_detail_coach_mark_widget.dart';
import 'package:chord_list_app/features/box/presentation/widgets/box_edit_dialog.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/box_chord_detail_model.dart';
import 'package:chord_list_app/shared/providers/analytics_provider.dart';
import 'package:chord_list_app/shared/providers/database_provider.dart';
import 'package:chord_list_app/shared/providers/preference_provider.dart';
import 'package:chord_list_app/shared/template/c_dialog.dart';
import 'package:chord_list_app/shared/template/c_scaffold.dart';
import 'package:chord_list_app/shared/template/c_toast.dart';
import 'package:chord_list_app/shared/template/future_value_widget.dart';
import 'package:chord_list_app/shared/widgets/chord_position_card_widget.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:intl/intl.dart';
import 'package:reorderables/reorderables.dart';

class BoxDetailScreen extends HookConsumerWidget {
  static String get routeName => '5f521d4b-5fa2-480d-8d43-d1726b013ba3';

  const BoxDetailScreen({super.key, required this.boxId});

  final int boxId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = useState(false);
    final editingDetails = useState<List<BoxChordDetailModel>>([]);
    final isSaving = useState(false);
    final isGuideVisible = useState(false);

    useEffect(() {
      ref.read(analyticsProvider).logScreenView('box_detail');
      return null;
    }, const []);

    useEffect(() {
      ref.read(preferenceRepositoryProvider).findBoxDetailGuideDone().then((isDone) {
        if (!isDone) isGuideVisible.value = true;
      });
      return null;
    }, const []);

    return Stack(
      children: [
        FutureValueWidget(
      ref.watch(boxDetailViewModelProvider(boxId).future),
      data: (data) {
        final BoxDetailState(box: box, chordDetails: chordDetails) = data;
        final dateStr = DateFormat('yyyy. M. d').format(box.createdAt);
        final isLandscape =
            MediaQuery.orientationOf(context) == Orientation.landscape;
        final crossAxisCount = isLandscape ? 4 : 2;
        final screenWidth = MediaQuery.sizeOf(context).width;
        final cardWidth =
            (screenWidth - 40 - 12 * (crossAxisCount - 1)) / crossAxisCount;

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

        Future<void> onSaveTap() async {
          isSaving.value = true;
          final db = ref.read(appDatabaseProvider);
          try {
            await db.boxChordDao.saveEditChanges(
              boxId,
              editingDetails.value.map((d) => d.position.id).toList(),
            );
            if (context.mounted) isEditing.value = false;
          } catch (_) {
            if (context.mounted) {
              isSaving.value = false;
              CToast.show(context, '오류가 발생하였습니다.');
            }
          }
        }

        return CScaffold(
          title: Text(
            isEditing.value ? '편집' : box.title,
            style: context.textTheme.semiBold16,
          ),
          leading: isEditing.value
              ? TextButton(
                  onPressed: () => isEditing.value = false,
                  child: const Text('취소'),
                )
              : null,
          actions: isEditing.value
              ? [
                  TextButton(
                    onPressed: isSaving.value ? null : onSaveTap,
                    child: const Text('저장'),
                  ),
                ]
              : [
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
              if (isEditing.value)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: ReorderableWrap(
                      spacing: 12,
                      runSpacing: 12,
                      maxMainAxisCount: crossAxisCount,
                      onReorder: (oldIndex, newIndex) {
                        final list = List<BoxChordDetailModel>.from(
                          editingDetails.value,
                        );
                        final item = list.removeAt(oldIndex);
                        list.insert(newIndex, item);
                        editingDetails.value = list;
                      },
                      children: editingDetails.value
                          .map(
                            (detail) => _ShakeWidget(
                              key: ValueKey(detail.position.id),
                              onDelete: () {
                                editingDetails.value = editingDetails.value
                                    .where(
                                      (d) =>
                                          d.position.id != detail.position.id,
                                    )
                                    .toList();
                              },
                              child: SizedBox(
                                width: cardWidth,
                                height: cardWidth,
                                child: ChordPositionCardWidget(
                                  chord: detail.chord,
                                  position: detail.position,
                                  onTap: () {},
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              else if (chordDetails.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('저장된 코드가 없습니다.')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final detail = chordDetails[index];
                      return GestureDetector(
                        onLongPress: () {
                          editingDetails.value = List.from(chordDetails);
                          isEditing.value = true;
                        },
                        child: ChordPositionCardWidget(
                          chord: detail.chord,
                          position: detail.position,
                          onTap: () {},
                        ),
                      );
                    }, childCount: chordDetails.length),
                  ),
                ),
            ],
          ),
        );
      },
        ),
        if (isGuideVisible.value)
          BoxDetailCoachMarkWidget(
            onConfirm: () => isGuideVisible.value = false,
            onDismiss: () async {
              await ref.read(preferenceRepositoryProvider).saveBoxDetailGuideDone();
              isGuideVisible.value = false;
            },
          ),
      ],
    );
  }
}

class _ShakeWidget extends HookWidget {
  const _ShakeWidget({super.key, required this.child, required this.onDelete});

  final Widget child;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    useEffect(() {
      controller.repeat(reverse: true);
      return () => controller.stop();
    }, const []);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final angle = (controller.value - 0.5) * pi / 90;
        return Transform.rotate(
          angle: angle,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              child,
              Positioned(
                top: -8,
                left: -8,
                child: GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    CupertinoIcons.minus_circle_fill,
                    size: 24,
                    color: AppColors.brandPurple,
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
