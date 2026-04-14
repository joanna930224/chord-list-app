import 'package:chord_list_app/shared/data/db/app_database.dart';

class ChordWithPositionsModel {
  const ChordWithPositionsModel({
    required this.chord,
    required this.positions,
  });

  final Chord chord;
  final List<ChordPosition> positions;
}
