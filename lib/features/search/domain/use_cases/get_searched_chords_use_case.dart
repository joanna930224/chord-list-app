import 'package:chord_list_app/shared/models/chord_with_positions_model.dart';

class GetSearchedChordsUseCase {
  const GetSearchedChordsUseCase();

  List<ChordWithPositionsModel> call(
    List<ChordWithPositionsModel> allChords,
    String query,
  ) {
    if (query.trim().isEmpty) return allChords;
    final normalized = _translateKorean(query.toLowerCase().trim());
    final matched =
        allChords.where((item) => _matchesQuery(item, normalized)).toList();
    matched.sort(
      (a, b) => _score(b, normalized).compareTo(_score(a, normalized)),
    );
    return matched;
  }

  // 긴 표현을 먼저 치환해야 메이저세븐이 메이저+세븐으로 분리되지 않음
  static const _korToEng = {
    '메이저세븐': 'maj7',
    '마이너세븐': 'm7',
    '메이저': 'major',
    '마이너': 'minor',
    '세븐': '7',
    '디미니시드': 'dim',
    '디미': 'dim',
    '오그멘티드': 'aug',
    '어그': 'aug',
    '서스': 'sus',
    '파워': 'power',
    '올터드': 'alt',
  };

  static String _translateKorean(String query) {
    var result = query;
    for (final entry in _korToEng.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  // 공백 제거 버전도 비교해 'emajor' ↔ 'e major' 매칭 지원
  static bool _matchesQuery(
    ChordWithPositionsModel item,
    String normalizedQuery,
  ) {
    final chord = item.chord;
    final targets = [
      chord.name.toLowerCase(),
      chord.fullName.toLowerCase(),
      if (chord.aliases != null) chord.aliases!.toLowerCase(),
    ];
    final targetsNoSpace =
        targets.map((t) => t.replaceAll(' ', '')).toList();

    final tokens = normalizedQuery
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    return tokens.every((token) {
      return targets.any((t) => t.contains(token)) ||
          targetsNoSpace.any((t) => t.contains(token));
    });
  }

  // 높을수록 상위 노출: exact > startsWith > contains
  // aliases(이명동음)는 name과 동일한 우선순위로 취급
  static int _score(
    ChordWithPositionsModel item,
    String normalizedQuery,
  ) {
    final name = item.chord.name.toLowerCase();
    final fullName = item.chord.fullName.toLowerCase();
    final alias = item.chord.aliases?.toLowerCase();
    final nameNoSpace = name.replaceAll(' ', '');
    final fullNameNoSpace = fullName.replaceAll(' ', '');
    final aliasNoSpace = alias?.replaceAll(' ', '');
    final queryNoSpace = normalizedQuery.replaceAll(' ', '');

    if (name == normalizedQuery || nameNoSpace == queryNoSpace) { return 100; }
    if (alias != null &&
        (alias == normalizedQuery || aliasNoSpace == queryNoSpace)) { return 100; }
    if (fullName == normalizedQuery || fullNameNoSpace == queryNoSpace) { return 90; }
    if (name.startsWith(normalizedQuery) ||
        nameNoSpace.startsWith(queryNoSpace)) { return 80; }
    if (alias != null &&
        (alias.startsWith(normalizedQuery) ||
            aliasNoSpace!.startsWith(queryNoSpace))) { return 80; }
    if (fullName.startsWith(normalizedQuery) ||
        fullNameNoSpace.startsWith(queryNoSpace)) { return 70; }
    if (name.contains(normalizedQuery) ||
        nameNoSpace.contains(queryNoSpace)) { return 60; }
    if (alias != null &&
        (alias.contains(normalizedQuery) ||
            aliasNoSpace!.contains(queryNoSpace))) { return 60; }
    if (fullName.contains(normalizedQuery) ||
        fullNameNoSpace.contains(queryNoSpace)) { return 50; }
    return 10;
  }
}
