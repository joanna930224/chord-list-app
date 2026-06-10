import 'package:chord_list_app/shared/models/chord_root.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';
import 'package:chord_list_app/shared/models/chord_with_positions_model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'library_state.g.dart';

@CopyWith()
class LibraryState {
  const LibraryState({
    this.selectedRoot = ChordRoot.c,
    this.selectedType = ChordType.major,
    this.types = const [],
    this.chordPositions = const [],
  });

  final ChordRoot selectedRoot;
  final ChordType selectedType;
  final List<ChordType> types;
  final List<ChordWithPositionsModel> chordPositions;
}
