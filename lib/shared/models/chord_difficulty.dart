enum ChordDifficulty { beginner, intermediate, advanced }

extension ChordDifficultyExtension on ChordDifficulty {
  /// DB 저장/조회 키
  String get dbKey => switch (this) {
    ChordDifficulty.beginner => 'beginner',
    ChordDifficulty.intermediate => 'intermediate',
    ChordDifficulty.advanced => 'advanced',
  };
}
