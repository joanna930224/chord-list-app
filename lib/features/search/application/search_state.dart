import 'package:chord_list_app/shared/models/chord_with_positions_model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'search_state.g.dart';

@CopyWith()
class SearchState {
  const SearchState({
    this.query = '',
    this.recentChords = const [],
    this.allChords = const [],
    this.filteredChords = const [],
  });

  final String query;
  final List<ChordWithPositionsModel> recentChords;
  final List<ChordWithPositionsModel> allChords;
  final List<ChordWithPositionsModel> filteredChords;
}
