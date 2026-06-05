import 'dart:async';

import 'package:chord_list_app/features/box/application/box_detail_state.dart';
import 'package:chord_list_app/features/box/domain/models/chord_box_model.dart';
import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/models/box_chord_detail_model.dart';
import 'package:chord_list_app/shared/providers/database_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final boxDetailViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<BoxDetailViewModelNotifier, BoxDetailState, int>(
  BoxDetailViewModelNotifier.new,
);

class BoxDetailViewModelNotifier extends AsyncNotifier<BoxDetailState> {
  BoxDetailViewModelNotifier(this._boxId);

  final int _boxId;
  StreamSubscription<List<BoxChordDetailModel>>? _subscription;

  @override
  Future<BoxDetailState> build() async {
    final db = ref.watch(appDatabaseProvider);

    ref.onDispose(() => _subscription?.cancel());

    final box = await db.boxDao.findById(_boxId);
    if (box == null) throw Exception('Box not found: $_boxId');

    final initialDetails =
        await db.boxChordDao.watchByBoxIdWithDetails(_boxId).first;
    _subscribe(db, _boxId);
    return BoxDetailState(
      box: ChordBoxModel.fromData(box),
      chordDetails: initialDetails,
    );
  }

  Future<void> refreshBox() async {
    final db = ref.read(appDatabaseProvider);
    final box = await db.boxDao.findById(_boxId);
    if (box == null || !state.hasValue) return;
    state = AsyncData(state.value!.copyWith(box: ChordBoxModel.fromData(box)));
  }

  Future<void> saveCustomChord({
    required String name,
    required String frets,
    required String fingers,
    required int baseFret,
  }) async {
    final db = ref.read(appDatabaseProvider);
    await db.transaction(() async {
      final chordId = await db.chordDao.insertCustomChord(name);
      final positionId = await db.chordPositionDao.insertPosition(
        ChordPositionsCompanion.insert(
          chordId: chordId,
          baseFret: baseFret,
          frets: frets,
          fingers: fingers,
          positionIndex: 0,
        ),
      );
      await db.boxChordDao.insertBoxChord(_boxId, positionId);
    });
  }

  /// 편집 모드 저장: 커스텀 코드 orphan 정리 + BoxChord 삭제/순서 저장
  Future<void> saveEditing(List<BoxChordDetailModel> remainingDetails) async {
    final db = ref.read(appDatabaseProvider);
    final currentDetails = state.value?.chordDetails ?? [];
    final remainingIds = remainingDetails.map((d) => d.position.id).toSet();
    final removedDetails =
        currentDetails.where((d) => !remainingIds.contains(d.position.id));

    await db.transaction(() async {
      for (final detail in removedDetails.where((d) => d.chord.isCustom)) {
        await db.chordPositionDao.deleteById(detail.position.id);
        await db.chordDao.deleteById(detail.chord.id);
      }
      await db.boxChordDao.saveEditChanges(
        _boxId,
        remainingDetails.map((d) => d.position.id).toList(),
      );
    });
  }

  Future<void> deleteBox() async {
    final db = ref.read(appDatabaseProvider);
    await db.boxDao.deleteById(_boxId);
  }

  void _subscribe(AppDatabase db, int boxId) {
    _subscription?.cancel();
    _subscription =
        db.boxChordDao.watchByBoxIdWithDetails(boxId).listen((details) {
      if (state.hasValue) {
        state = AsyncData(state.value!.copyWith(chordDetails: details));
      }
    });
  }
}
