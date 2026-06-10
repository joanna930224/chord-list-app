import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/models/chord_root.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';
import 'package:chord_list_app/shared/models/chord_with_positions_model.dart';

class GetChordPositionsUseCase {
  const GetChordPositionsUseCase(this._db);

  final AppDatabase _db;

  /// root + type으로 Chord 목록을 조회하고 각 운지법을 묶어 반환
  Future<List<ChordWithPositionsModel>> call({
    required ChordRoot root,
    required ChordType type,
  }) async {
    final chords = await _db.chordDao.findByRoot(root.dbKey);
    final filtered = chords.where((c) => c.type == type.dbKey).toList();

    final result = <ChordWithPositionsModel>[];
    for (final chord in filtered) {
      final positions = await _db.chordPositionDao.findByChordId(chord.id);
      result.add(ChordWithPositionsModel(chord: chord, positions: positions));
    }
    return result;
  }
}
