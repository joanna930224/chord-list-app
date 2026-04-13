import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/data/db/dao/box_dao.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.memory();
    await db.chordDao.findAll(); // onCreate 트리거 (seed 포함)
  });

  tearDown(() async {
    await db.close();
  });

  BoxesCompanion _companion({
    String title = 'Test Box',
    String? description,
  }) =>
      BoxesCompanion.insert(
        title: title,
        description: Value(description),
        createdAt: DateTime(2026, 1, 1),
      );

  group('BoxDao - insert / findById', () {
    test('insertBox: 삽입 후 findById로 조회되어야 한다', () async {
      final id = await db.boxDao.insertBox(_companion(title: 'My Box'));
      final found = await db.boxDao.findById(id);
      expect(found, isNotNull);
      expect(found!.title, equals('My Box'));
    });

    test('findById: 존재하지 않는 id는 null을 반환해야 한다', () async {
      final found = await db.boxDao.findById(999999);
      expect(found, isNull);
    });

    test('insertBox: description이 null이어도 삽입되어야 한다', () async {
      final id = await db.boxDao.insertBox(_companion(description: null));
      final found = await db.boxDao.findById(id);
      expect(found!.description, isNull);
    });
  });

  group('BoxDao - watchAll 정렬', () {
    setUp(() async {
      await db.boxDao.insertBox(
        BoxesCompanion.insert(
          title: 'B Box',
          description: const Value(null),
          createdAt: DateTime(2026, 1, 1),
        ),
      );
      await db.boxDao.insertBox(
        BoxesCompanion.insert(
          title: 'A Box',
          description: const Value(null),
          createdAt: DateTime(2026, 1, 2),
        ),
      );
    });

    test('createdAtDesc: 최근 생성순 정렬', () async {
      final list = await db.boxDao.watchAll(BoxSortType.createdAtDesc).first;
      expect(list.first.title, equals('A Box'));
    });

    test('createdAtAsc: 오래된 생성순 정렬', () async {
      final list = await db.boxDao.watchAll(BoxSortType.createdAtAsc).first;
      expect(list.first.title, equals('B Box'));
    });

    test('titleAsc: 제목 오름차순 정렬', () async {
      final list = await db.boxDao.watchAll(BoxSortType.titleAsc).first;
      expect(list.first.title, equals('A Box'));
    });

    test('titleDesc: 제목 내림차순 정렬', () async {
      final list = await db.boxDao.watchAll(BoxSortType.titleDesc).first;
      expect(list.first.title, equals('B Box'));
    });
  });

  group('BoxDao - deleteById', () {
    test('deleteById: 삭제 후 findById는 null을 반환해야 한다', () async {
      final id = await db.boxDao.insertBox(_companion());
      await db.boxDao.deleteById(id);
      final found = await db.boxDao.findById(id);
      expect(found, isNull);
    });
  });
}
