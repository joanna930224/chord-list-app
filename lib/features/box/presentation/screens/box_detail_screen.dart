import 'package:chord_list_app/features/box/application/box_detail_state.dart';
import 'package:chord_list_app/features/box/application/box_detail_view_model_provider.dart';
import 'package:chord_list_app/shared/widgets/chord_position_card_widget.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_scaffold.dart';
import 'package:chord_list_app/shared/template/future_value_widget.dart';
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

        return CScaffold(
          title: Text(box.title, style: context.textTheme.semiBold16),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {}, // Phase 2에서 구현
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
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final detail = chordDetails[index];
                      return ChordPositionCardWidget(
                        chord: detail.chord,
                        position: detail.position,
                        onTap: () {},
                      );
                    }, childCount: chordDetails.length),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
