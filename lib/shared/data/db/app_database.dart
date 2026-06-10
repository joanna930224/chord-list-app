import 'package:chord_list_app/shared/data/db/dao/box_chord_dao.dart';
import 'package:chord_list_app/shared/data/db/dao/box_dao.dart';
import 'package:chord_list_app/shared/data/db/dao/chord_dao.dart';
import 'package:chord_list_app/shared/data/db/dao/chord_position_dao.dart';
import 'package:chord_list_app/shared/data/db/dao/recently_searched_chord_dao.dart';
import 'package:chord_list_app/shared/data/db/seed/chord_seed_data.dart';
import 'package:chord_list_app/shared/data/db/tables/box_chords_table.dart';
import 'package:chord_list_app/shared/data/db/tables/boxes_table.dart';
import 'package:chord_list_app/shared/data/db/tables/chord_positions_table.dart';
import 'package:chord_list_app/shared/data/db/tables/chords_table.dart';
import 'package:chord_list_app/shared/data/db/tables/recently_searched_chords_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Chords, ChordPositions, ChordBoxes, BoxChords, RecentlySearchedChords],
  daos: [ChordDao, ChordPositionDao, BoxDao, BoxChordDao, RecentlySearchedChordDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'chord_box.db'));

  @visibleForTesting
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await insertSeedData(this);
    },
  );
}
