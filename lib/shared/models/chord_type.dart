enum ChordType {
  // 기본
  major,
  minor,
  // 파워
  five,
  // 6th
  six,
  mSix,
  sixNine,
  mSixNine,
  // 7th
  seven,
  maj7,
  m7,
  mMaj7,
  sevenFlatFive,
  maj7FlatFive,
  m7FlatFive,
  mMaj7FlatFive,
  sevenFlatNine,
  sevenSharpNine,
  // Suspended
  sus2,
  sus4,
  sevenSusFour,
  sus2sus4,
  // Augmented
  aug,
  aug7,
  aug9,
  // Diminished
  dim,
  dim7,
  // 9th
  nine,
  maj9,
  m9,
  mMaj9,
  addNine,
  mAddNine,
  nineFlatFive,
  nineSharpEleven,
  // 11th
  eleven,
  maj11,
  m11,
  mMaj11,
  // 13th
  thirteen,
  maj13,
  // Altered
  alt;

  static ChordType fromDbKey(String key) =>
      ChordType.values.firstWhere((t) => t.dbKey == key);
}

extension ChordTypeExtension on ChordType {
  /// DB 저장/조회 키
  String get dbKey => switch (this) {
    ChordType.major => 'major',
    ChordType.minor => 'minor',
    ChordType.five => '5',
    ChordType.six => '6',
    ChordType.mSix => 'm6',
    ChordType.sixNine => '69',
    ChordType.mSixNine => 'm69',
    ChordType.seven => '7',
    ChordType.maj7 => 'maj7',
    ChordType.m7 => 'm7',
    ChordType.mMaj7 => 'mmaj7',
    ChordType.sevenFlatFive => '7b5',
    ChordType.maj7FlatFive => 'maj7b5',
    ChordType.m7FlatFive => 'm7b5',
    ChordType.mMaj7FlatFive => 'mmaj7b5',
    ChordType.sevenFlatNine => '7b9',
    ChordType.sevenSharpNine => '7#9',
    ChordType.sus2 => 'sus2',
    ChordType.sus4 => 'sus4',
    ChordType.sevenSusFour => '7sus4',
    ChordType.sus2sus4 => 'sus2sus4',
    ChordType.aug => 'aug',
    ChordType.aug7 => 'aug7',
    ChordType.aug9 => 'aug9',
    ChordType.dim => 'dim',
    ChordType.dim7 => 'dim7',
    ChordType.nine => '9',
    ChordType.maj9 => 'maj9',
    ChordType.m9 => 'm9',
    ChordType.mMaj9 => 'mmaj9',
    ChordType.addNine => 'add9',
    ChordType.mAddNine => 'madd9',
    ChordType.nineFlatFive => '9b5',
    ChordType.nineSharpEleven => '9#11',
    ChordType.eleven => '11',
    ChordType.maj11 => 'maj11',
    ChordType.m11 => 'm11',
    ChordType.mMaj11 => 'mmaj11',
    ChordType.thirteen => '13',
    ChordType.maj13 => 'maj13',
    ChordType.alt => 'alt',
  };

  /// 코드명 suffix (예: major → '', minor → 'm', seven → '7')
  String get nameSuffix => switch (this) {
    ChordType.major => '',
    ChordType.minor => 'm',
    _ => dbKey,
  };

  /// 전체 영문명
  String get fullName => switch (this) {
    ChordType.major => 'major',
    ChordType.minor => 'minor',
    ChordType.five => 'power chord',
    ChordType.six => '6th',
    ChordType.mSix => 'minor 6th',
    ChordType.sixNine => '6th add 9th',
    ChordType.mSixNine => 'minor 6th add 9th',
    ChordType.seven => 'dominant 7th',
    ChordType.maj7 => 'major 7th',
    ChordType.m7 => 'minor 7th',
    ChordType.mMaj7 => 'minor major 7th',
    ChordType.sevenFlatFive => 'dominant 7th flat 5',
    ChordType.maj7FlatFive => 'major 7th flat 5',
    ChordType.m7FlatFive => 'minor 7th flat 5',
    ChordType.mMaj7FlatFive => 'minor major 7th flat 5',
    ChordType.sevenFlatNine => 'dominant 7th flat 9',
    ChordType.sevenSharpNine => 'dominant 7th sharp 9',
    ChordType.sus2 => 'suspended 2nd',
    ChordType.sus4 => 'suspended 4th',
    ChordType.sevenSusFour => 'dominant 7th suspended 4th',
    ChordType.sus2sus4 => 'suspended 2nd and 4th',
    ChordType.aug => 'augmented',
    ChordType.aug7 => 'augmented 7th',
    ChordType.aug9 => 'augmented 9th',
    ChordType.dim => 'diminished',
    ChordType.dim7 => 'diminished 7th',
    ChordType.nine => '9th',
    ChordType.maj9 => 'major 9th',
    ChordType.m9 => 'minor 9th',
    ChordType.mMaj9 => 'minor major 9th',
    ChordType.addNine => 'add 9th',
    ChordType.mAddNine => 'minor add 9th',
    ChordType.nineFlatFive => '9th flat 5',
    ChordType.nineSharpEleven => '9th sharp 11',
    ChordType.eleven => '11th',
    ChordType.maj11 => 'major 11th',
    ChordType.m11 => 'minor 11th',
    ChordType.mMaj11 => 'minor major 11th',
    ChordType.thirteen => '13th',
    ChordType.maj13 => 'major 13th',
    ChordType.alt => 'altered',
  };
}
