import 'package:chord_list_app/shared/data/db/tables/boxes_table.dart';
import 'package:chord_list_app/shared/data/db/tables/chord_positions_table.dart';
import 'package:drift/drift.dart';

class BoxChords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get boxId => integer().references(ChordBoxes, #id)();
  IntColumn get chordPositionId => integer().references(ChordPositions, #id)();
  DateTimeColumn get savedAt => dateTime()();
  IntColumn get sortOrder => integer()();
}
