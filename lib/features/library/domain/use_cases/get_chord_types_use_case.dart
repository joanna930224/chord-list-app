import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/models/chord_root.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';

class GetChordTypesUseCase {
  const GetChordTypesUseCase(this._db);

  final AppDatabase _db;

  /// root 음에 해당하는 코드 타입 목록을 중복 제거하여 반환
  Future<List<ChordType>> call(ChordRoot root) async {
    final chords = await _db.chordDao.findByRoot(root.dbKey);
    return chords.map((c) => ChordType.fromDbKey(c.type)).toSet().toList();
  }
}
