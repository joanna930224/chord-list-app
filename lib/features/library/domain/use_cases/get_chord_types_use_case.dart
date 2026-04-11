import 'package:chord_list_app/shared/data/db/app_database.dart';

class GetChordTypesUseCase {
  const GetChordTypesUseCase(this._db);

  final AppDatabase _db;

  /// root 음에 해당하는 코드 타입 목록을 중복 제거하여 반환
  Future<List<String>> call(String root) async {
    final chords = await _db.chordDao.findByRoot(root);
    final types = chords.map((c) => c.type).toSet().toList();
    return types;
  }
}
