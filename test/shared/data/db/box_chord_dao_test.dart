import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late int boxId;
  late int chordPositionId;

  setUp(() async {
    db = AppDatabase.memory();
    await db.chordDao.findAll(); // onCreate 트리거 (seed 포함)

    boxId = await db.boxDao.insertBox(
      ChordBoxesCompanion.insert(
        title: 'Test Box',
        description: const Value(null),
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    // seed된 첫 번째 ChordPosition id 사용
    final positions = await db.chordPositionDao.findByChordId(1);
    chordPositionId = positions.first.id;
  });

  tearDown(() async {
    await db.close();
  });

  BoxChordsCompanion companion({int? boxIdOverride, int? positionIdOverride}) =>
      BoxChordsCompanion.insert(
        boxId: boxIdOverride ?? boxId,
        chordPositionId: positionIdOverride ?? chordPositionId,
        savedAt: DateTime(2026, 1, 1),
      );

  group('BoxChordDao - insertBoxChord / watchByBoxId', () {
    test('insertBoxChord: 삽입 후 watchByBoxId로 조회되어야 한다', () async {
      await db.boxChordDao.insertBoxChord(companion());
      final list = await db.boxChordDao.watchByBoxId(boxId).first;
      expect(list, isNotEmpty);
      expect(list.first.chordPositionId, equals(chordPositionId));
    });

    test('watchByBoxId: 다른 boxId의 데이터는 포함되지 않아야 한다', () async {
      final otherBoxId = await db.boxDao.insertBox(
        ChordBoxesCompanion.insert(
          title: 'Other Box',
          description: const Value(null),
          createdAt: DateTime(2026, 1, 2),
        ),
      );

      await db.boxChordDao.insertBoxChord(companion(boxIdOverride: otherBoxId));

      final list = await db.boxChordDao.watchByBoxId(boxId).first;
      expect(list, isEmpty);
    });
  });

  group('BoxChordDao - existsInBox', () {
    test('existsInBox: 저장된 항목은 true를 반환해야 한다', () async {
      await db.boxChordDao.insertBoxChord(companion());
      final exists = await db.boxChordDao.existsInBox(boxId, chordPositionId);
      expect(exists, isTrue);
    });

    test('existsInBox: 저장되지 않은 항목은 false를 반환해야 한다', () async {
      final exists = await db.boxChordDao.existsInBox(boxId, chordPositionId);
      expect(exists, isFalse);
    });
  });

  group('BoxChordDao - deleteBoxChord', () {
    test('deleteBoxChord: 삭제 후 watchByBoxId 목록에서 제거되어야 한다', () async {
      await db.boxChordDao.insertBoxChord(companion());
      await db.boxChordDao.deleteBoxChord(boxId, chordPositionId);
      final list = await db.boxChordDao.watchByBoxId(boxId).first;
      expect(list, isEmpty);
    });
  });
}
