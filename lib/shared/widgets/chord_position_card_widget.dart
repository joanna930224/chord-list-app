import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/haptic_provider.dart';
import 'package:flutter_guitar_chord/flutter_guitar_chord.dart';

class ChordPositionCardWidget extends ConsumerWidget {
  const ChordPositionCardWidget({
    super.key,
    required this.chord,
    required this.position,
    required this.onTap,
  });

  final Chord chord;
  final ChordPosition position;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hapticService = ref.read(hapticProvider);
    final diagramColor = context.colorScheme.primary;

    return GestureDetector(
      onTap: () {
        hapticService.light();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colorScheme.outline, width: 0.5),
        ),
        padding: const EdgeInsets.fromLTRB(4, 4, 0, 2),
        child: FlutterGuitarChord(
          frets: position.frets,
          fingers: position.fingers,
          fingerSize: 16,
          stringStroke: 1,
          baseFret: position.baseFret,
          chordName: chord.name,
          stringColor: diagramColor,
          barColor: diagramColor,
          firstFrameColor: diagramColor,
          tabBackgroundColor: diagramColor,
          tabForegroundColor: context.colorScheme.onPrimary,
          labelColor: diagramColor,
          mutedColor: context.colorScheme.secondary,
        ),
      ),
    );
  }
}
