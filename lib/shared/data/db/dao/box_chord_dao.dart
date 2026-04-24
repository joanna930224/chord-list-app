import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/data/db/tables/box_chords_table.dart';
import 'package:chord_list_app/shared/data/db/tables/chord_positions_table.dart';
import 'package:chord_list_app/shared/data/db/tables/chords_table.dart';
import 'package:chord_list_app/shared/models/box_chord_detail_model.dart';
import 'package:drift/drift.dart';

part 'box_chord_dao.g.dart';

@DriftAccessor(tables: [BoxChords, ChordPositions, Chords])
class BoxChordDao extends DatabaseAccessor<AppDatabase>
    with _$BoxChordDaoMixin {
  BoxChordDao(super.db);

  /// 특정 Box의 코드 목록 조회 (Stream)
  Stream<List<BoxChord>> watchByBoxId(int boxId) =>
      (select(boxChords)
            ..where((t) => t.boxId.equals(boxId))
            ..orderBy([(t) => OrderingTerm.desc(t.savedAt)]))
          .watch();

  /// 코드 저장
  Future<int> insertBoxChord(BoxChordsCompanion companion) =>
      into(boxChords).insert(companion);

  /// 중복 확인
  Future<bool> existsInBox(int boxId, int chordPositionId) async {
    final result =
        await (select(boxChords)..where(
              (t) =>
                  t.boxId.equals(boxId) &
                  t.chordPositionId.equals(chordPositionId),
            ))
            .getSingleOrNull();
    return result != null;
  }

  /// 특정 Box에서 코드 삭제
  Future<int> deleteBoxChord(int boxId, int chordPositionId) =>
      (delete(boxChords)..where(
            (t) =>
                t.boxId.equals(boxId) &
                t.chordPositionId.equals(chordPositionId),
          ))
          .go();

  /// Box에 저장된 코드 상세 목록 조회 (Chord + ChordPosition join, Stream)
  Stream<List<BoxChordDetailModel>> watchByBoxIdWithDetails(int boxId) {
    final query =
        select(boxChords).join([
            innerJoin(
              chordPositions,
              chordPositions.id.equalsExp(boxChords.chordPositionId),
            ),
            innerJoin(chords, chords.id.equalsExp(chordPositions.chordId)),
          ])
          ..where(boxChords.boxId.equals(boxId))
          ..orderBy([OrderingTerm.asc(boxChords.savedAt)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => BoxChordDetailModel(
              chord: row.readTable(chords),
              position: row.readTable(chordPositions),
              savedAt: row.readTable(boxChords).savedAt,
            ),
          )
          .toList(),
    );
  }
}
