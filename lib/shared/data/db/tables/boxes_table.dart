import 'package:drift/drift.dart';

@DataClassName('ChordBox')
class Boxes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
