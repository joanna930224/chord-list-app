import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
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

  group('ChordDao - 조회', () {
    test('findAll: 전체 코드 목록이 비어있지 않아야 한다', () async {
      final result = await db.chordDao.findAll();
      expect(result, isNotEmpty);
    });

    test('findByRoot: 지정한 root만 반환해야 한다', () async {
      final result = await db.chordDao.findByRoot('G');
      expect(result, isNotEmpty);
      expect(result.every((c) => c.root == 'G'), isTrue);
    });

    test('findByType: 지정한 type만 반환해야 한다', () async {
      final result = await db.chordDao.findByType('minor');
      expect(result, isNotEmpty);
      expect(result.every((c) => c.type == 'minor'), isTrue);
    });

    test('search: name으로 검색되어야 한다', () async {
      final result = await db.chordDao.search('Am');
      expect(result, isNotEmpty);
      expect(
        result.every(
          (c) =>
              c.name.contains('Am') ||
              c.fullName.contains('Am'),
        ),
        isTrue,
      );
    });

    test('search: fullName으로 검색되어야 한다', () async {
      final result = await db.chordDao.search('major 7th');
      expect(result, isNotEmpty);
    });

    test('findById: 존재하는 id로 단건 조회되어야 한다', () async {
      final all = await db.chordDao.findAll();
      final target = all.first;
      final found = await db.chordDao.findById(target.id);
      expect(found, isNotNull);
      expect(found!.id, equals(target.id));
    });

    test('findById: 존재하지 않는 id는 null을 반환해야 한다', () async {
      final found = await db.chordDao.findById(999999);
      expect(found, isNull);
    });
  });

  group('ChordDao - CRUD', () {
    test('insertChord: 삽입 후 findById로 조회되어야 한다', () async {
      final newId = await db.chordDao.insertChord(
        ChordsCompanion.insert(
          name: 'TestChord',
          fullName: 'Test Chord full',
          root: 'C',
          type: 'test',
          difficulty: 'beginner',
        ),
      );
      final found = await db.chordDao.findById(newId);
      expect(found, isNotNull);
      expect(found!.name, equals('TestChord'));
    });

    test('updateChord: 수정 후 변경된 값이 반영되어야 한다', () async {
      final all = await db.chordDao.findAll();
      final target = all.first;

      await db.chordDao.updateChord(
        target.toCompanion(true).copyWith(difficulty: const Value('advanced')),
      );

      final updated = await db.chordDao.findById(target.id);
      expect(updated!.difficulty, equals('advanced'));
    });

    test('deleteById: 삭제 후 findById는 null을 반환해야 한다', () async {
      final newId = await db.chordDao.insertChord(
        ChordsCompanion.insert(
          name: 'ToDelete',
          fullName: 'To Delete',
          root: 'C',
          type: 'test',
          difficulty: 'beginner',
        ),
      );
      await db.chordDao.deleteById(newId);
      final found = await db.chordDao.findById(newId);
      expect(found, isNull);
    });
  });
}
