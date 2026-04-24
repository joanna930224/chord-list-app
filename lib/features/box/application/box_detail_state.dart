import 'package:chord_list_app/features/box/domain/models/chord_box_model.dart';
import 'package:chord_list_app/shared/models/box_chord_detail_model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'box_detail_state.g.dart';

@CopyWith()
class BoxDetailState {
  const BoxDetailState({required this.box, this.chordDetails = const []});

  final ChordBoxModel box;
  final List<BoxChordDetailModel> chordDetails;
}
