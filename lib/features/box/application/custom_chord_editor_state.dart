import 'package:copy_with_extension/copy_with_extension.dart';

part 'custom_chord_editor_state.g.dart';

@CopyWith()
class CustomChordEditorState {
  const CustomChordEditorState({
    required this.frets,
    required this.baseFret,
    required this.chordName,
    required this.fingers,
  });

  /// 각 줄의 운지 값: -1 = 뮤트, 0 = 오픈, 1+ = 프렛 번호
  final List<int> frets;

  /// 시작 프렛 (1-based)
  final int baseFret;

  final String chordName;

  /// 각 줄의 손가락 번호: '0' = 미지정, 'T' = 엄지, '1'~'4' = 검지~소지
  final List<String> fingers;

  factory CustomChordEditorState.initial() => const CustomChordEditorState(
    frets: [0, 0, 0, 0, 0, 0],
    baseFret: 1,
    chordName: '',
    fingers: ['0', '0', '0', '0', '0', '0'],
  );

  String get fretsString => frets.join(' ');

  String get fingersString => fingers.join(' ');

  bool get isValid => chordName.trim().isNotEmpty;
}
