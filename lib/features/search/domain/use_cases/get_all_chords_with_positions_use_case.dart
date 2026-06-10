import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/models/chord_with_positions_model.dart';

class GetAllChordsWithPositionsUseCase {
  const GetAllChordsWithPositionsUseCase(this._db);

  final AppDatabase _db;

  Future<List<ChordWithPositionsModel>> call() async {
    final chords = await _db.chordDao.findAllStandard();
    final result = <ChordWithPositionsModel>[];
    for (final chord in chords) {
      final positions = await _db.chordPositionDao.findByChordId(chord.id);
      result.add(ChordWithPositionsModel(chord: chord, positions: positions));
    }
    return result;
  }
}
