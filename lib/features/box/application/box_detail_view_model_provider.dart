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

    _subscribe(db, _boxId);

    final initialDetails =
        await db.boxChordDao.watchByBoxIdWithDetails(_boxId).first;
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
