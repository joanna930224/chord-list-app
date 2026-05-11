import 'package:chord_list_app/shared/data/db/tables/chords_table.dart';
import 'package:drift/drift.dart';

class RecentlySearchedChords extends Table {
  IntColumn get chordId => integer().references(Chords, #id)();
  DateTimeColumn get searchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {chordId};
}
