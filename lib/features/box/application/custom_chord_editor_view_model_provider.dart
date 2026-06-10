import 'package:chord_list_app/features/box/application/custom_chord_editor_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final customChordEditorViewModelProvider = NotifierProvider.autoDispose<
    CustomChordEditorViewModelNotifier, CustomChordEditorState>(
  CustomChordEditorViewModelNotifier.new,
);

class CustomChordEditorViewModelNotifier
    extends Notifier<CustomChordEditorState> {
  @override
  CustomChordEditorState build() => CustomChordEditorState.initial();

  void updateChordName(String name) {
    state = state.copyWith(chordName: name);
  }

  void updateBaseFret(int baseFret) {
    state = state.copyWith(baseFret: baseFret);
  }

  void selectFret(int stringIndex, int fret) {
    final newFrets = List<int>.from(state.frets);
    final newFingers = List<String>.from(state.fingers);
    newFrets[stringIndex] = fret;
    if (fret == 0) {
      newFingers[stringIndex] = '0';
    } else if (state.frets[stringIndex] <= 0) {
      newFingers[stringIndex] = _nextFinger(stringIndex);
    }
    state = state.copyWith(frets: newFrets, fingers: newFingers);
  }

  void toggleMute(int stringIndex) {
    final newFrets = List<int>.from(state.frets);
    final newFingers = List<String>.from(state.fingers);
    newFrets[stringIndex] = state.frets[stringIndex] == -1 ? 0 : -1;
    newFingers[stringIndex] = '0';
    state = state.copyWith(frets: newFrets, fingers: newFingers);
  }

  void updateFinger(int stringIndex, String finger) {
    final newFingers = List<String>.from(state.fingers);
    newFingers[stringIndex] = finger;
    state = state.copyWith(fingers: newFingers);
  }

  String _nextFinger(int excludeString) {
    final usedFingers = <int>[];
    for (int i = 0; i < state.frets.length; i++) {
      if (i == excludeString) continue;
      if (state.frets[i] > 0) {
        final f = state.fingers[i];
        if (f != '0' && f != 'T') {
          final n = int.tryParse(f);
          if (n != null) usedFingers.add(n);
        }
      }
    }
    if (usedFingers.isEmpty) return '1';
    final maxUsed = usedFingers.reduce((a, b) => a > b ? a : b);
    return maxUsed < 4 ? '${maxUsed + 1}' : '4';
  }
}
