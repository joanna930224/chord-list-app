import 'package:chord_list_app/features/search/domain/use_cases/record_recently_searched_use_case.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/chord_with_positions_model.dart';
import 'package:chord_list_app/shared/providers/database_provider.dart';
import 'package:chord_list_app/shared/template/c_scaffold.dart';
import 'package:chord_list_app/shared/template/future_value_widget.dart';
import 'package:chord_list_app/shared/utils/chord_save_actions.dart';
import 'package:chord_list_app/shared/widgets/chord_position_card_widget.dart';

class ChordDetailScreen extends HookConsumerWidget {
  static String get routeName => 'a3f7c2e1-84b9-4d6f-bc01-2e5a9f3d7c8b';

  const ChordDetailScreen({super.key, required this.chordId});

  final int chordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);

    final future = useMemoized(() async {
      final chord = await db.chordDao.findById(chordId);
      if (chord == null) throw Exception('코드를 찾을 수 없습니다.');
      final positions = await db.chordPositionDao.findByChordId(chord.id);
      return ChordWithPositionsModel(chord: chord, positions: positions);
    }, [chordId]);

    useEffect(() {
      RecordRecentlySearchedUseCase(db).call(chordId);
      return null;
    }, const []);

    return FutureValueWidget(
      future,
      data: (item) {
        final isLandscape =
            MediaQuery.orientationOf(context) == Orientation.landscape;
        final crossAxisCount = isLandscape ? 4 : 2;

        return CScaffold(
          title: Text(item.chord.fullName, style: context.textTheme.semiBold16),
          body: item.positions.isEmpty
              ? Center(
                  child: Text(
                    '운지법이 없습니다.',
                    style: context.textTheme.regular14.copyWith(
                      color: context.colorScheme.secondary,
                    ),
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final position = item.positions[index];
                          return ChordPositionCardWidget(
                            chord: item.chord,
                            position: position,
                            onTap: () => showChordSaveBottomSheet(
                              context,
                              item.chord,
                              position,
                            ),
                          );
                        }, childCount: item.positions.length),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
