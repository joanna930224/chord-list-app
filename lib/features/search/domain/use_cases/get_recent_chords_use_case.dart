import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/models/chord_with_positions_model.dart';

class GetRecentChordsUseCase {
  const GetRecentChordsUseCase(this._db);

  final AppDatabase _db;

  Future<List<ChordWithPositionsModel>> call({int limit = 20}) async {
    final recent = await _db.recentlySearchedChordDao.findRecent(limit: limit);
    final result = <ChordWithPositionsModel>[];
    for (final row in recent) {
      final chord = await _db.chordDao.findById(row.chordId);
      if (chord == null) continue;
      final positions = await _db.chordPositionDao.findByChordId(chord.id);
      result.add(ChordWithPositionsModel(chord: chord, positions: positions));
    }
    return result;
  }
}
