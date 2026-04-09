import 'package:chord_list_app/shared/data/db/app_database.dart' hide ChordPosition;
import 'package:chord_list_app/shared/utils/logger.dart';
import 'package:drift/drift.dart';
import 'package:guitar_chord_library/guitar_chord_library.dart';

Future<void> insertSeedData(AppDatabase db) async {
  logger.d('✅ [Seed] 시작 - 초기 코드 데이터 삽입');
  final instrument = GuitarChordLibrary.instrument(InstrumentType.guitar);

  // 패키지는 샵(#) 표기만 지원. b(플랫) 이명동음은 aliases에 저장
  const roots = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B',
  ];

  // 일반 코드 타입 (베이스음 없음)
  const regularTypes = [
    // 기본
    'major', 'minor',
    // 파워
    '5',
    // 6th
    '6', 'm6', '69', 'm69',
    // 7th
    '7', 'maj7', 'm7', 'mmaj7',
    '7b5', 'maj7b5', 'm7b5', 'mmaj7b5',
    '7b9', '7#9',
    // Suspended
    'sus2', 'sus4', '7sus4', 'sus2sus4',
    // Augmented
    'aug', 'aug7', 'aug9',
    // Diminished
    'dim', 'dim7',
    // 9th
    '9', 'maj9', 'm9', 'mmaj9', 'add9', 'madd9', '9b5', '9#11',
    // 11th
    '11', 'maj11', 'm11', 'mmaj11',
    // 13th
    '13', 'maj13',
    // Altered
    'alt',
  ];

  // 슬래시 코드: (패키지 suffix, 기본 타입, 베이스음)
  // type과 bass를 분리하여 root/type/bass 구조로 정규화
  const slashChords = [
    // major over bass
    ('/A',   'major', 'A'),
    ('/A#',  'major', 'A#'),
    ('/B',   'major', 'B'),
    ('/C',   'major', 'C'),
    ('/C#',  'major', 'C#'),
    ('/D',   'major', 'D'),
    ('/D#',  'major', 'D#'),
    ('/E',   'major', 'E'),
    ('/F',   'major', 'F'),
    ('/F#',  'major', 'F#'),
    ('/G',   'major', 'G'),
    ('/G#',  'major', 'G#'),
    // minor over bass
    ('m/B',  'minor', 'B'),
    ('m/C',  'minor', 'C'),
    ('m/C#', 'minor', 'C#'),
    ('m/D',  'minor', 'D'),
    ('m/D#', 'minor', 'D#'),
    ('m/E',  'minor', 'E'),
    ('m/F',  'minor', 'F'),
    ('m/F#', 'minor', 'F#'),
    ('m/G',  'minor', 'G'),
    ('m/G#', 'minor', 'G#'),
    // 7th over bass
    ('7/G',  '7',     'G'),
  ];

  await db.transaction(() async {
    for (final root in roots) {
      // 일반 코드
      for (final type in regularTypes) {
        final positions = instrument.getChordPositions(root, type);
        if (positions == null || positions.isEmpty) continue;
        await _insertChord(db, root: root, type: type, bass: null, positions: positions);
      }

      // 슬래시 코드
      for (final (suffix, type, bass) in slashChords) {
        final positions = instrument.getChordPositions(root, suffix);
        if (positions == null || positions.isEmpty) continue;
        await _insertChord(db, root: root, type: type, bass: bass, positions: positions);
      }
    }
  });

  logger.d('✅ [Seed] 완료');
}

Future<void> _insertChord(
  AppDatabase db, {
  required String root,
  required String type,
  required String? bass,
  required List<ChordPosition> positions,
}) async {
  final isBarreChord = positions.any((p) => p.baseFret > 1);

  final chordId = await db.into(db.chords).insert(
        ChordsCompanion.insert(
          name: _buildName(root, type, bass),
          fullName: _buildFullName(root, type, bass),
          root: root,
          type: type,
          bass: Value(bass),
          difficulty: _difficulty(type, isBarreChord),
          isBarreChord: Value(isBarreChord),
          aliases: Value(_flatAlias(root, type, bass)),
        ),
      );

  for (var i = 0; i < positions.length; i++) {
    final pos = positions[i];
    await db.into(db.chordPositions).insert(
          ChordPositionsCompanion.insert(
            chordId: chordId,
            baseFret: pos.baseFret,
            frets: pos.frets,
            fingers: pos.fingers,
            positionIndex: i,
          ),
        );
  }
}

/// 코드 표기명 (예: C, Cm, C7, C/E, Cm/G)
String _buildName(String root, String type, String? bass) {
  final base = type == 'major'
      ? root
      : type == 'minor'
          ? '${root}m'
          : '$root$type';
  return bass != null ? '$base/$bass' : base;
}

/// 코드 전체명 (예: C major, C minor over E bass)
String _buildFullName(String root, String type, String? bass) {
  const fullNames = {
    'major':    'major',
    'minor':    'minor',
    '5':        'power chord',
    '6':        '6th',
    'm6':       'minor 6th',
    '69':       '6th add 9th',
    'm69':      'minor 6th add 9th',
    '7':        'dominant 7th',
    'maj7':     'major 7th',
    'm7':       'minor 7th',
    'mmaj7':    'minor major 7th',
    '7b5':      'dominant 7th flat 5',
    'maj7b5':   'major 7th flat 5',
    'm7b5':     'minor 7th flat 5',
    'mmaj7b5':  'minor major 7th flat 5',
    '7b9':      'dominant 7th flat 9',
    '7#9':      'dominant 7th sharp 9',
    'sus2':     'suspended 2nd',
    'sus4':     'suspended 4th',
    '7sus4':    'dominant 7th suspended 4th',
    'sus2sus4': 'suspended 2nd and 4th',
    'aug':      'augmented',
    'aug7':     'augmented 7th',
    'aug9':     'augmented 9th',
    'dim':      'diminished',
    'dim7':     'diminished 7th',
    '9':        '9th',
    'maj9':     'major 9th',
    'm9':       'minor 9th',
    'mmaj9':    'minor major 9th',
    'add9':     'add 9th',
    'madd9':    'minor add 9th',
    '9b5':      '9th flat 5',
    '9#11':     '9th sharp 11',
    '11':       '11th',
    'maj11':    'major 11th',
    'm11':      'minor 11th',
    'mmaj11':   'minor major 11th',
    '13':       '13th',
    'maj13':    'major 13th',
    'alt':      'altered',
  };

  final baseName = '$root ${fullNames[type] ?? type}';
  return bass != null ? '$baseName over $bass bass' : baseName;
}

/// # 루트의 b 이명동음 별칭 (예: C#m7 → Dbm7, C#/E → Db/E)
String? _flatAlias(String root, String type, String? bass) {
  const flatMap = {
    'C#': 'Db', 'D#': 'Eb', 'F#': 'Gb', 'G#': 'Ab', 'A#': 'Bb',
  };
  final flat = flatMap[root];
  if (flat == null) return null;

  final flatBase = type == 'major'
      ? flat
      : type == 'minor'
          ? '${flat}m'
          : '$flat$type';
  return bass != null ? '$flatBase/$bass' : flatBase;
}

/// 난이도 산정
String _difficulty(String type, bool isBarreChord) {
  if (isBarreChord) return 'advanced';

  const beginner = {'major', 'minor', '5', 'sus2', 'sus4'};
  const intermediate = {
    '7', 'maj7', 'm7', '6', 'm6', 'dim', 'aug',
    'add9', 'madd9', '9', '7sus4', '69', 'm69', 'sus2sus4',
  };

  if (beginner.contains(type)) return 'beginner';
  if (intermediate.contains(type)) return 'intermediate';
  return 'advanced';
}
