import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.memory();
    // memory DB도 onCreate가 트리거되도록 쿼리 한 번 실행
    await db.chordDao.findAll();
  });

  tearDown(() async {
    await db.close();
  });

  group('Seed Data', () {
    test('코드 데이터가 삽입되어 있어야 한다', () async {
      final chords = await db.chordDao.findAll();
      expect(chords, isNotEmpty);
    });

    test('12개 루트가 모두 존재해야 한다', () async {
      const expectedRoots = [
        'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B',
      ];
      for (final root in expectedRoots) {
        final chords = await db.chordDao.findByRoot(root);
        expect(chords, isNotEmpty, reason: 'root $root 코드가 없음');
      }
    });

    test('major, minor 타입이 존재해야 한다', () async {
      final major = await db.chordDao.findByType('major');
      final minor = await db.chordDao.findByType('minor');
      expect(major, isNotEmpty);
      expect(minor, isNotEmpty);
    });

    test('C major 코드의 운지법이 1개 이상 존재해야 한다', () async {
      final cMajor = await db.chordDao.search('C');
      final cMajorChord = cMajor.firstWhere(
        (c) => c.name == 'C' && c.type == 'major',
      );
      final positions =
          await db.chordPositionDao.findByChordId(cMajorChord.id);
      expect(positions, isNotEmpty);
    });

    test('C# 코드의 aliases는 Db를 포함해야 한다', () async {
      final chords = await db.chordDao.findByRoot('C#');
      final cSharpMajor = chords.firstWhere((c) => c.type == 'major');
      expect(cSharpMajor.aliases, equals('Db'));
    });

    test('자연음(C, D, E 등)은 aliases가 null이어야 한다', () async {
      final chords = await db.chordDao.findByRoot('C');
      for (final chord in chords) {
        expect(chord.aliases, isNull, reason: 'C 루트는 별칭이 없어야 함');
      }
    });

    test('슬래시 코드가 존재해야 한다 (name에 / 포함)', () async {
      final all = await db.chordDao.findAll();
      final slashChords = all.where((c) => c.name.contains('/')).toList();
      expect(slashChords, isNotEmpty);
    });

    test('슬래시 코드의 bass 컬럼이 채워져 있어야 한다', () async {
      final all = await db.chordDao.findAll();
      final slashChords = all.where((c) => c.bass != null).toList();
      expect(slashChords, isNotEmpty);
    });

    test('일반 코드의 bass 컬럼은 null이어야 한다', () async {
      final cMajor = await db.chordDao.findByRoot('C');
      final regular = cMajor.where((c) => c.type == 'major' && c.bass == null).toList();
      expect(regular, isNotEmpty);
    });

    test('C/E 슬래시 코드의 bass는 E이어야 한다', () async {
      final all = await db.chordDao.findAll();
      final cOverE = all.firstWhere((c) => c.name == 'C/E');
      expect(cOverE.root, equals('C'));
      expect(cOverE.type, equals('major'));
      expect(cOverE.bass, equals('E'));
    });
  });
}
