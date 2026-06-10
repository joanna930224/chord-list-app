import 'package:chord_list_app/features/search/application/search_state.dart';
import 'package:chord_list_app/features/search/domain/use_cases/get_all_chords_with_positions_use_case.dart';
import 'package:chord_list_app/features/search/domain/use_cases/get_recent_chords_use_case.dart';
import 'package:chord_list_app/features/search/domain/use_cases/get_searched_chords_use_case.dart';
import 'package:chord_list_app/shared/providers/database_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchViewModelProvider =
    AsyncNotifierProvider.autoDispose<SearchViewModelNotifier, SearchState>(
      SearchViewModelNotifier.new,
    );

class SearchViewModelNotifier extends AsyncNotifier<SearchState> {
  late GetRecentChordsUseCase _getRecentChords;
  late GetAllChordsWithPositionsUseCase _getAllChords;
  final _getSearchedChords = const GetSearchedChordsUseCase();

  @override
  Future<SearchState> build() async {
    final db = ref.watch(appDatabaseProvider);
    _getRecentChords = GetRecentChordsUseCase(db);
    _getAllChords = GetAllChordsWithPositionsUseCase(db);

    final recentChords = await _getRecentChords();
    final allChords = await _getAllChords();

    return SearchState(
      recentChords: recentChords,
      allChords: allChords,
      filteredChords: allChords,
    );
  }

  Future<void> search(String query) async {
    final current = await future;
    final filtered = _getSearchedChords(current.allChords, query);
    state = AsyncData(current.copyWith(query: query, filteredChords: filtered));
  }

  Future<void> refreshRecent() async {
    final current = await future;
    final recentChords = await _getRecentChords();
    state = AsyncData(current.copyWith(recentChords: recentChords));
  }
}
