import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';

extension ChordDisplayExtension on Chord {
  String displayName(ChordNotationStyle style) {
    final chordType = ChordType.fromDbKey(type);
    final suffix = switch (style) {
      ChordNotationStyle.symbol => chordType.symbolNotation,
      ChordNotationStyle.text => chordType.textNotation,
    };
    return '$root$suffix${bass != null ? '/$bass' : ''}';
  }
}
