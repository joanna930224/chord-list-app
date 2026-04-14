import 'dart:async';

import 'package:chord_list_app/features/box/application/box_state.dart';
import 'package:chord_list_app/features/box/domain/models/chord_box_model.dart';
import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/data/db/dao/box_dao.dart';
import 'package:chord_list_app/shared/providers/database_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final boxViewModelProvider =
    AsyncNotifierProvider.autoDispose<BoxViewModelNotifier, BoxState>(
      BoxViewModelNotifier.new,
    );

class BoxViewModelNotifier extends AsyncNotifier<BoxState> {
  StreamSubscription<List<ChordBox>>? _subscription;

  @override
  Future<BoxState> build() async {
    final db = ref.watch(appDatabaseProvider);

    ref.onDispose(() => _subscription?.cancel());

    const initialSort = BoxSortType.createdAtDesc;
    _subscribe(db, initialSort);

    final data = await db.boxDao.watchAll(initialSort).first;
    return BoxState(
      boxes: data.map<ChordBoxModel>(ChordBoxModel.fromData).toList(),
      sortType: initialSort,
    );
  }

  void _subscribe(AppDatabase db, BoxSortType sortType) {
    _subscription?.cancel();
    _subscription = db.boxDao.watchAll(sortType).listen((data) {
      if (state.hasValue) {
        state = AsyncData(
          state.value!.copyWith(boxes: data.map<ChordBoxModel>(ChordBoxModel.fromData).toList()),
        );
      }
    });
  }

  /// 정렬 기준 변경
  Future<void> changeSortType(BoxSortType sortType) async {
    final current = await future;
    final db = ref.read(appDatabaseProvider);
    _subscribe(db, sortType);
    final data = await db.boxDao.watchAll(sortType).first;
    state = AsyncData(
      current.copyWith(
        boxes: data.map<ChordBoxModel>(ChordBoxModel.fromData).toList(),
        sortType: sortType,
      ),
    );
  }
}
