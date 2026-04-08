import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/data/db/tables/chords_table.dart';
import 'package:drift/drift.dart';

part 'chord_dao.g.dart';

@DriftAccessor(tables: [Chords])
class ChordDao extends DatabaseAccessor<AppDatabase> with _$ChordDaoMixin {
  ChordDao(super.db);

  /// 전체 코드 목록 조회
  Future<List<Chord>> findAll() => select(chords).get();

  /// root 음으로 필터링
  Future<List<Chord>> findByRoot(String root) =>
      (select(chords)..where((t) => t.root.equals(root))).get();

  /// type으로 필터링
  Future<List<Chord>> findByType(String type) =>
      (select(chords)..where((t) => t.type.equals(type))).get();

  /// name 또는 fullName으로 검색
  Future<List<Chord>> search(String keyword) => (select(chords)
        ..where(
          (t) =>
              t.name.contains(keyword) |
              t.fullName.contains(keyword),
        ))
      .get();

  /// 단일 코드 조회
  Future<Chord?> findById(int id) =>
      (select(chords)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// 코드 삽입
  Future<int> insertChord(ChordsCompanion companion) =>
      into(chords).insert(companion);

  /// 코드 수정
  Future<bool> updateChord(ChordsCompanion companion) =>
      update(chords).replace(companion);

  /// 코드 삭제
  Future<int> deleteById(int id) =>
      (delete(chords)..where((t) => t.id.equals(id))).go();
}
