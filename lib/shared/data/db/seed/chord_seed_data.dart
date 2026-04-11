import 'package:chord_list_app/shared/data/db/app_database.dart'
    hide ChordPosition;
import 'package:chord_list_app/shared/models/chord_difficulty.dart';
import 'package:chord_list_app/shared/models/chord_root.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';
import 'package:chord_list_app/shared/utils/logger.dart';
import 'package:drift/drift.dart';
import 'package:guitar_chord_library/guitar_chord_library.dart';

Future<void> insertSeedData(AppDatabase db) async {
  logger.d('✅ [Seed] 시작 - 초기 코드 데이터 삽입');
  final instrument = GuitarChordLibrary.instrument(InstrumentType.guitar);

  // 슬래시 코드: (패키지 suffix, 코드 타입, 베이스음)
  const slashChords = [
    // major over bass
    ('/A', ChordType.major, ChordRoot.a),
    ('/A#', ChordType.major, ChordRoot.aSharp),
    ('/B', ChordType.major, ChordRoot.b),
    ('/C', ChordType.major, ChordRoot.c),
    ('/C#', ChordType.major, ChordRoot.cSharp),
    ('/D', ChordType.major, ChordRoot.d),
    ('/D#', ChordType.major, ChordRoot.dSharp),
    ('/E', ChordType.major, ChordRoot.e),
    ('/F', ChordType.major, ChordRoot.f),
    ('/F#', ChordType.major, ChordRoot.fSharp),
    ('/G', ChordType.major, ChordRoot.g),
    ('/G#', ChordType.major, ChordRoot.gSharp),
    // minor over bass
    ('m/B', ChordType.minor, ChordRoot.b),
    ('m/C', ChordType.minor, ChordRoot.c),
    ('m/C#', ChordType.minor, ChordRoot.cSharp),
    ('m/D', ChordType.minor, ChordRoot.d),
    ('m/D#', ChordType.minor, ChordRoot.dSharp),
    ('m/E', ChordType.minor, ChordRoot.e),
    ('m/F', ChordType.minor, ChordRoot.f),
    ('m/F#', ChordType.minor, ChordRoot.fSharp),
    ('m/G', ChordType.minor, ChordRoot.g),
    ('m/G#', ChordType.minor, ChordRoot.gSharp),
    // 7th over bass
    ('7/G', ChordType.seven, ChordRoot.g),
  ];

  await db.transaction(() async {
    for (final root in ChordRoot.values) {
      // 일반 코드
      for (final type in ChordType.values) {
        final positions = instrument.getChordPositions(root.dbKey, type.dbKey);
        if (positions == null || positions.isEmpty) continue;
        await _insertChord(
          db,
          root: root,
          type: type,
          bass: null,
          positions: positions,
        );
      }

      // 슬래시 코드
      for (final (suffix, type, bass) in slashChords) {
        final positions = instrument.getChordPositions(root.dbKey, suffix);
        if (positions == null || positions.isEmpty) continue;
        await _insertChord(
          db,
          root: root,
          type: type,
          bass: bass,
          positions: positions,
        );
      }
    }
  });

  logger.d('✅ [Seed] 완료');
}

Future<void> _insertChord(
  AppDatabase db, {
  required ChordRoot root,
  required ChordType type,
  required ChordRoot? bass,
  required List<ChordPosition> positions,
}) async {
  final isBarreChord = positions.any((p) => p.baseFret > 1);
  final difficulty = _difficulty(type, isBarreChord);

  final chordId = await db
      .into(db.chords)
      .insert(
        ChordsCompanion.insert(
          name: _buildName(root, type, bass),
          fullName: _buildFullName(root, type, bass),
          root: root.dbKey,
          type: type.dbKey,
          bass: Value(bass?.dbKey),
          difficulty: difficulty.dbKey,
          isBarreChord: Value(isBarreChord),
          aliases: Value(_flatAlias(root, type, bass)),
        ),
      );

  for (var i = 0; i < positions.length; i++) {
    final pos = positions[i];
    await db
        .into(db.chordPositions)
        .insert(
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
String _buildName(ChordRoot root, ChordType type, ChordRoot? bass) {
  final base = '${root.dbKey}${type.nameSuffix}';
  return bass != null ? '$base/${bass.dbKey}' : base;
}

/// 코드 전체명 (예: C major, C minor over E bass)
String _buildFullName(ChordRoot root, ChordType type, ChordRoot? bass) {
  final baseName = '${root.dbKey} ${type.fullName}';
  return bass != null ? '$baseName over ${bass.dbKey} bass' : baseName;
}

/// # 루트의 b 이명동음 별칭 (예: C#m7 → Dbm7, C#/E → Db/E)
String? _flatAlias(ChordRoot root, ChordType type, ChordRoot? bass) {
  final flat = root.flatKey;
  if (flat == null) return null;

  final flatBase = '$flat${type.nameSuffix}';
  return bass != null ? '$flatBase/${bass.dbKey}' : flatBase;
}

/// 난이도 산정
ChordDifficulty _difficulty(ChordType type, bool isBarreChord) {
  if (isBarreChord) return ChordDifficulty.advanced;

  const beginner = {
    ChordType.major,
    ChordType.minor,
    ChordType.five,
    ChordType.sus2,
    ChordType.sus4,
  };
  const intermediate = {
    ChordType.seven,
    ChordType.maj7,
    ChordType.m7,
    ChordType.six,
    ChordType.mSix,
    ChordType.dim,
    ChordType.aug,
    ChordType.addNine,
    ChordType.mAddNine,
    ChordType.nine,
    ChordType.sevenSusFour,
    ChordType.sixNine,
    ChordType.mSixNine,
    ChordType.sus2sus4,
  };

  if (beginner.contains(type)) return ChordDifficulty.beginner;
  if (intermediate.contains(type)) return ChordDifficulty.intermediate;
  return ChordDifficulty.advanced;
}
