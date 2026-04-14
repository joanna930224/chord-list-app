import 'package:chord_list_app/features/box/domain/models/chord_box_model.dart';
import 'package:chord_list_app/shared/data/db/dao/box_dao.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'box_state.g.dart';

@CopyWith()
class BoxState {
  const BoxState({
    this.boxes = const [],
    this.sortType = BoxSortType.createdAtDesc,
  });

  final List<ChordBoxModel> boxes;
  final BoxSortType sortType;
}
