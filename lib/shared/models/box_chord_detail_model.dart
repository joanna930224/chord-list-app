import 'package:chord_list_app/shared/data/db/app_database.dart';

class BoxChordDetailModel {
  const BoxChordDetailModel({
    required this.chord,
    required this.position,
    required this.savedAt,
  });

  final Chord chord;
  final ChordPosition position;
  final DateTime savedAt;
}
