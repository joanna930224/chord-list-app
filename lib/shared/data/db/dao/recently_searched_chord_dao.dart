import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/data/db/tables/recently_searched_chords_table.dart';
import 'package:drift/drift.dart';

part 'recently_searched_chord_dao.g.dart';

@DriftAccessor(tables: [RecentlySearchedChords])
class RecentlySearchedChordDao extends DatabaseAccessor<AppDatabase>
    with _$RecentlySearchedChordDaoMixin {
  RecentlySearchedChordDao(super.db);

  /// 코드 탭 시 기록 (이미 있으면 searchedAt 갱신)
  Future<void> upsert(int chordId) => into(recentlySearchedChords)
      .insertOnConflictUpdate(
        RecentlySearchedChordsCompanion(
          chordId: Value(chordId),
          searchedAt: Value(DateTime.now()),
        ),
      );

  /// 최근 검색한 코드 목록 (searchedAt 내림차순)
  Future<List<RecentlySearchedChord>> findRecent({int limit = 20}) =>
      (select(recentlySearchedChords)
            ..orderBy([(t) => OrderingTerm.desc(t.searchedAt)])
            ..limit(limit))
          .get();

  /// 전체 삭제
  Future<int> deleteAll() => delete(recentlySearchedChords).go();
}
