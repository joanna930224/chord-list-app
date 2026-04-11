import 'package:chord_list_app/features/library/domain/models/chord_with_positions_model.dart';
import 'package:chord_list_app/shared/data/db/app_database.dart';

class GetChordPositionsUseCase {
  const GetChordPositionsUseCase(this._db);

  final AppDatabase _db;

  /// root + type으로 Chord 목록을 조회하고 각 운지법을 묶어 반환
  Future<List<ChordWithPositions>> call({
    required String root,
    required String type,
  }) async {
    final chords = await _db.chordDao.findByRoot(root);
    final filtered = chords.where((c) => c.type == type).toList();

    final result = <ChordWithPositions>[];
    for (final chord in filtered) {
      final positions = await _db.chordPositionDao.findByChordId(chord.id);
      result.add(ChordWithPositions(chord: chord, positions: positions));
    }
    return result;
  }
}
