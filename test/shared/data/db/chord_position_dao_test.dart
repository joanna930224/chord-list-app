import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.memory();
    await db.chordDao.findAll(); // onCreate 트리거
  });

  tearDown(() async {
    await db.close();
  });

  group('ChordPositionDao - 조회', () {
    test('findByChordId: seed된 코드의 운지법이 1개 이상이어야 한다', () async {
      final all = await db.chordDao.findAll();
      final target = all.first;
      final positions = await db.chordPositionDao.findByChordId(target.id);
      expect(positions, isNotEmpty);
    });

    test('findByChordId: positionIndex 오름차순으로 정렬되어야 한다', () async {
      final all = await db.chordDao.findAll();
      final target = all.first;
      final positions = await db.chordPositionDao.findByChordId(target.id);

      for (var i = 0; i < positions.length - 1; i++) {
        expect(
          positions[i].positionIndex,
          lessThanOrEqualTo(positions[i + 1].positionIndex),
        );
      }
    });

    test('findByChordId: 존재하지 않는 chordId는 빈 목록을 반환해야 한다', () async {
      final positions = await db.chordPositionDao.findByChordId(999999);
      expect(positions, isEmpty);
    });
  });

  group('ChordPositionDao - CRUD', () {
    test('insertPosition: 삽입 후 findByChordId로 조회되어야 한다', () async {
      final chordId = await db.chordDao.insertChord(
        ChordsCompanion.insert(
          name: 'TestChord',
          fullName: 'Test Chord',
          root: 'C',
          type: 'test',
          difficulty: 'beginner',
        ),
      );

      await db.chordPositionDao.insertPosition(
        ChordPositionsCompanion.insert(
          chordId: chordId,
          baseFret: 1,
          frets: '-1 3 2 0 1 0',
          fingers: '0 3 2 0 1 0',
          positionIndex: 0,
        ),
      );

      final positions = await db.chordPositionDao.findByChordId(chordId);
      expect(positions.length, equals(1));
      expect(positions.first.frets, equals('-1 3 2 0 1 0'));
    });

    test('deleteByChordId: 삭제 후 해당 코드의 운지법은 빈 목록이어야 한다', () async {
      final chordId = await db.chordDao.insertChord(
        ChordsCompanion.insert(
          name: 'ToDelete',
          fullName: 'To Delete',
          root: 'C',
          type: 'test',
          difficulty: 'beginner',
        ),
      );

      await db.chordPositionDao.insertPosition(
        ChordPositionsCompanion.insert(
          chordId: chordId,
          baseFret: 1,
          frets: '0 2 2 1 0 0',
          fingers: '0 2 3 1 0 0',
          positionIndex: 0,
        ),
      );

      await db.chordPositionDao.deleteByChordId(chordId);
      final positions = await db.chordPositionDao.findByChordId(chordId);
      expect(positions, isEmpty);
    });
  });
}
