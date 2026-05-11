import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late int chordId;

  setUp(() async {
    db = AppDatabase.memory();
    await db.chordDao.findAll(); // onCreate 트리거 (seed 포함)

    // seed된 첫 번째 Chord id 사용
    final chords = await db.chordDao.findAll();
    chordId = chords.first.id;
  });

  tearDown(() async {
    await db.close();
  });

  group('RecentlySearchedChordDao - upsert / findRecent', () {
    test('upsert: 삽입 후 findRecent에 조회되어야 한다', () async {
      await db.recentlySearchedChordDao.upsert(chordId);
      final list = await db.recentlySearchedChordDao.findRecent();
      expect(list, isNotEmpty);
      expect(list.first.chordId, equals(chordId));
    });

    test('upsert: 동일 chordId 재호출 시 행이 1개만 존재해야 한다', () async {
      await db.recentlySearchedChordDao.upsert(chordId);
      await db.recentlySearchedChordDao.upsert(chordId);
      final list = await db.recentlySearchedChordDao.findRecent();
      expect(list.length, equals(1));
    });

    test('upsert: 재호출 시 searchedAt이 갱신되어야 한다', () async {
      await db.recentlySearchedChordDao.upsert(chordId);
      final before = (await db.recentlySearchedChordDao.findRecent()).first.searchedAt;

      await Future<void>.delayed(const Duration(seconds: 1));
      await db.recentlySearchedChordDao.upsert(chordId);
      final after = (await db.recentlySearchedChordDao.findRecent()).first.searchedAt;

      expect(after.isAfter(before), isTrue);
    });

    test('findRecent: limit 이하로 반환되어야 한다', () async {
      final chords = await db.chordDao.findAll();
      for (final chord in chords.take(5)) {
        await db.recentlySearchedChordDao.upsert(chord.id);
      }
      final list = await db.recentlySearchedChordDao.findRecent(limit: 3);
      expect(list.length, equals(3));
    });

    test('findRecent: searchedAt 내림차순으로 반환되어야 한다', () async {
      final chords = await db.chordDao.findAll();
      final id1 = chords[0].id;
      final id2 = chords[1].id;

      await db.recentlySearchedChordDao.upsert(id1);
      await Future<void>.delayed(const Duration(seconds: 1));
      await db.recentlySearchedChordDao.upsert(id2);

      final list = await db.recentlySearchedChordDao.findRecent();
      expect(list.length, equals(2));
      expect(list.first.chordId, equals(id2));
      expect(list.last.chordId, equals(id1));
    });
  });

  group('RecentlySearchedChordDao - deleteAll', () {
    test('deleteAll: 전체 삭제 후 findRecent가 빈 목록을 반환해야 한다', () async {
      await db.recentlySearchedChordDao.upsert(chordId);
      await db.recentlySearchedChordDao.deleteAll();
      final list = await db.recentlySearchedChordDao.findRecent();
      expect(list, isEmpty);
    });
  });
}
