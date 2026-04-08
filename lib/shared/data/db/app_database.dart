import 'package:chord_list_app/shared/data/db/dao/chord_dao.dart';
import 'package:chord_list_app/shared/data/db/dao/chord_position_dao.dart';
import 'package:chord_list_app/shared/data/db/tables/chord_positions_table.dart';
import 'package:chord_list_app/shared/data/db/tables/chords_table.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Chords, ChordPositions], daos: [ChordDao, ChordPositionDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'chord_box.db'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // seed는 Phase 4에서 추가
    },
  );
}
