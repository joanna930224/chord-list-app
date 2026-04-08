import 'package:drift/drift.dart';

class Chords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get fullName => text()();
  TextColumn get root => text()();
  TextColumn get type => text()();
  TextColumn get difficulty => text()();
  BoolColumn get isBarreChord => boolean().withDefault(const Constant(false))();
  TextColumn get aliases => text().nullable()();
}
