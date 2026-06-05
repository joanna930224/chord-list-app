import 'package:chord_list_app/features/box/application/box_detail_view_model_provider.dart';
import 'package:chord_list_app/features/box/application/custom_chord_editor_view_model_provider.dart';
import 'package:chord_list_app/features/box/presentation/widgets/fretboard_widget.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/haptic_provider.dart';
import 'package:chord_list_app/shared/template/c_scaffold.dart';
import 'package:chord_list_app/shared/template/c_toast.dart';
import 'package:flutter_guitar_chord/flutter_guitar_chord.dart';

class CustomChordEditorScreen extends HookConsumerWidget {
  static String get routeName => '5660c30d-a935-4c5e-bd11-b86fc08f2367';

  const CustomChordEditorScreen({super.key, required this.boxId});

  final int boxId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customChordEditorViewModelProvider);
    final isSaving = useState(false);

    Future<void> onSave() async {
      isSaving.value = true;
      try {
        await ref
            .read(boxDetailViewModelProvider(boxId).notifier)
            .saveCustomChord(
              name: state.chordName.trim(),
              frets: state.fretsString,
              fingers: state.fingersString,
              baseFret: state.baseFret,
            );
        if (context.mounted) context.pop();
      } catch (_) {
        if (context.mounted) {
          isSaving.value = false;
          CToast.show(context, '오류가 발생하였습니다.');
        }
      }
    }

    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return CScaffold(
      title: const Text('Custom'),
      actions: [
        TextButton(
          onPressed: state.isValid && !isSaving.value ? onSave : null,
          child: const Text('저장'),
        ),
      ],
      body: isLandscape
          ? Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: const _FretboardControls().ph20,
                  ),
                ),
                const Expanded(child: _ChordPreview()),
              ],
            )
          : Column(
              children: [
                const SizedBox(height: 16),
                Expanded(child: const _FretboardControls().ph20),
                const _ChordPreview(),
              ],
            ),
    );
  }
}

class _FretboardControls extends ConsumerWidget {
  const _FretboardControls();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customChordEditorViewModelProvider);
    final notifier = ref.read(customChordEditorViewModelProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) => FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: constraints.maxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: notifier.updateChordName,
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: '코드 이름 (예: C, Am, G/B)',
                  counterText: '',
                  fillColor: context.colorScheme.surfaceContainerHighest,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.brandPurple,
                      width: 1.0,
                    ),
                  ),
                ),
                style: context.textTheme.regular16,
              ),
              const SizedBox(height: 24),
              FretboardWidget(
                frets: state.frets,
                baseFret: state.baseFret,
                fingers: state.fingers,
                onFretSelected: notifier.selectFret,
                onMuteToggled: (s) {
                  ref.read(hapticProvider).selection();
                  notifier.toggleMute(s);
                },
                onBaseFretChanged: notifier.updateBaseFret,
                onDialChanged: () => ref.read(hapticProvider).selection(),
                onFingerChanged: notifier.updateFinger,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChordPreview extends ConsumerWidget {
  const _ChordPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customChordEditorViewModelProvider);
    final diagramColor = context.colorScheme.primary;

    return ColoredBox(
      color: context.colorScheme.onPrimary,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text('미리보기', style: context.textTheme.semiBold14).ph20,
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 210,
                height: 210,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 4),
                  child: FlutterGuitarChord(
                    frets: state.fretsString,
                    fingers: state.fingersString,
                    baseFret: state.baseFret,
                    chordName: state.chordName.isEmpty ? '?' : state.chordName,
                    fingerSize: 18,
                    stringStroke: 1,
                    stringColor: diagramColor,
                    barColor: diagramColor,
                    firstFrameColor: diagramColor,
                    tabBackgroundColor: diagramColor,
                    tabForegroundColor: context.colorScheme.onPrimary,
                    labelColor: diagramColor,
                    mutedColor: context.colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
