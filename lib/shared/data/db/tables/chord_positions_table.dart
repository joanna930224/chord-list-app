import 'package:chord_list_app/shared/data/db/tables/chords_table.dart';
import 'package:drift/drift.dart';

class ChordPositions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chordId => integer().references(Chords, #id)();
  IntColumn get baseFret => integer()();
  TextColumn get frets => text()();
  TextColumn get fingers => text()();
  IntColumn get positionIndex => integer()();
}
