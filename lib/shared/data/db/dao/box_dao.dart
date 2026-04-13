import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/data/db/tables/boxes_table.dart';
import 'package:drift/drift.dart';

part 'box_dao.g.dart';

enum BoxSortType { createdAtDesc, createdAtAsc, titleAsc, titleDesc }

@DriftAccessor(tables: [Boxes])
class BoxDao extends DatabaseAccessor<AppDatabase> with _$BoxDaoMixin {
  BoxDao(super.db);

  /// 전체 Box 목록 조회 (정렬 조건 포함, Stream)
  Stream<List<ChordBox>> watchAll(BoxSortType sortType) {
    return (select(boxes)..orderBy([
          (t) => switch (sortType) {
            BoxSortType.createdAtDesc => OrderingTerm.desc(t.createdAt),
            BoxSortType.createdAtAsc => OrderingTerm.asc(t.createdAt),
            BoxSortType.titleAsc => OrderingTerm.asc(t.title),
            BoxSortType.titleDesc => OrderingTerm.desc(t.title),
          },
        ]))
        .watch();
  }

  /// 단일 Box 조회
  Future<ChordBox?> findById(int id) =>
      (select(boxes)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Box 생성
  Future<int> insertBox(BoxesCompanion companion) =>
      into(boxes).insert(companion);

  /// Box 삭제
  Future<int> deleteById(int id) =>
      (delete(boxes)..where((t) => t.id.equals(id))).go();
}
