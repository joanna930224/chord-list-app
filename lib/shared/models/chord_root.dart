enum ChordRoot { c, cSharp, d, dSharp, e, f, fSharp, g, gSharp, a, aSharp, b }

extension ChordRootExtension on ChordRoot {
  /// DB 조회 시 사용하는 키 (항상 # 표기)
  String get dbKey => switch (this) {
    ChordRoot.c => 'C',
    ChordRoot.cSharp => 'C#',
    ChordRoot.d => 'D',
    ChordRoot.dSharp => 'D#',
    ChordRoot.e => 'E',
    ChordRoot.f => 'F',
    ChordRoot.fSharp => 'F#',
    ChordRoot.g => 'G',
    ChordRoot.gSharp => 'G#',
    ChordRoot.a => 'A',
    ChordRoot.aSharp => 'A#',
    ChordRoot.b => 'B',
  };

  /// UI 표시 라벨 (이명동음은 이중 표기)
  String get label => switch (this) {
    ChordRoot.cSharp => 'C#•D♭',
    ChordRoot.dSharp => 'D#•E♭',
    ChordRoot.fSharp => 'F#•G♭',
    ChordRoot.gSharp => 'G#•A♭',
    ChordRoot.aSharp => 'A#•B♭',
    _ => dbKey,
  };

  /// b(플랫) 이명동음 표기 (샵 루트만 존재, 나머지는 null)
  String? get flatKey => switch (this) {
    ChordRoot.cSharp => 'Db',
    ChordRoot.dSharp => 'Eb',
    ChordRoot.fSharp => 'Gb',
    ChordRoot.gSharp => 'Ab',
    ChordRoot.aSharp => 'Bb',
    _ => null,
  };
}
