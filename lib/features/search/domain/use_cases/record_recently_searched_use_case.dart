import 'package:chord_list_app/shared/data/db/app_database.dart';

class RecordRecentlySearchedUseCase {
  const RecordRecentlySearchedUseCase(this._db);

  final AppDatabase _db;

  Future<void> call(int chordId) => _db.recentlySearchedChordDao.upsert(chordId);
}
