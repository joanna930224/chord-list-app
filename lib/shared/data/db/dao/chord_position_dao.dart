import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/data/db/tables/chord_positions_table.dart';
import 'package:drift/drift.dart';

part 'chord_position_dao.g.dart';

@DriftAccessor(tables: [ChordPositions])
class ChordPositionDao extends DatabaseAccessor<AppDatabase>
    with _$ChordPositionDaoMixin {
  ChordPositionDao(super.db);

  /// 특정 코드의 운지법 목록 조회
  Future<List<ChordPosition>> findByChordId(int chordId) =>
      (select(chordPositions)
            ..where((t) => t.chordId.equals(chordId))
            ..orderBy([(t) => OrderingTerm.asc(t.positionIndex)]))
          .get();

  /// 운지법 삽입
  Future<int> insertPosition(ChordPositionsCompanion companion) =>
      into(chordPositions).insert(companion);

  /// 운지법 단건 삭제
  Future<int> deleteById(int positionId) =>
      (delete(chordPositions)..where((t) => t.id.equals(positionId))).go();

  /// 특정 코드의 운지법 전체 삭제 (chord 삭제 시 수동 호출)
  Future<int> deleteByChordId(int chordId) =>
      (delete(chordPositions)..where((t) => t.chordId.equals(chordId))).go();
}
