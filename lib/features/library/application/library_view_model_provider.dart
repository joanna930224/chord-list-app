import 'package:chord_list_app/features/library/application/library_state.dart';
import 'package:chord_list_app/features/library/domain/use_cases/get_chord_positions_use_case.dart';
import 'package:chord_list_app/features/library/domain/use_cases/get_chord_types_use_case.dart';
import 'package:chord_list_app/shared/models/chord_root.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';
import 'package:chord_list_app/shared/providers/database_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final libraryViewModelProvider =
    AsyncNotifierProvider.autoDispose<LibraryViewModelNotifier, LibraryState>(
      LibraryViewModelNotifier.new,
    );

class LibraryViewModelNotifier extends AsyncNotifier<LibraryState> {
  late GetChordTypesUseCase _getChordTypes;
  late GetChordPositionsUseCase _getChordPositions;

  @override
  Future<LibraryState> build() async {
    final db = ref.watch(appDatabaseProvider);
    _getChordTypes = GetChordTypesUseCase(db);
    _getChordPositions = GetChordPositionsUseCase(db);

    const initialRoot = ChordRoot.c;
    const initialType = ChordType.major;

    final types = await _getChordTypes(initialRoot);
    final chordPositions = await _getChordPositions(
      root: initialRoot,
      type: initialType,
    );

    return LibraryState(
      selectedRoot: initialRoot,
      selectedType: initialType,
      types: types,
      chordPositions: chordPositions,
    );
  }

  /// 루트 변경 → 타입 목록 갱신 → 첫 번째 타입으로 운지 목록 갱신
  Future<void> selectRoot(ChordRoot root) async {
    state = await AsyncValue.guard(() async {
      final current = await future;
      final types = await _getChordTypes(root);
      final newType = types.contains(current.selectedType)
          ? current.selectedType
          : (types.isNotEmpty ? types.first : current.selectedType);
      final chordPositions = await _getChordPositions(
        root: root,
        type: newType,
      );
      return current.copyWith(
        selectedRoot: root,
        selectedType: newType,
        types: types,
        chordPositions: chordPositions,
      );
    });
  }

  /// 타입 변경 → 운지 목록 갱신
  Future<void> selectType(ChordType type) async {
    state = await AsyncValue.guard(() async {
      final current = await future;
      final chordPositions = await _getChordPositions(
        root: current.selectedRoot,
        type: type,
      );
      return current.copyWith(
        selectedType: type,
        chordPositions: chordPositions,
      );
    });
  }
}
