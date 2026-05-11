import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/chord_with_positions_model.dart';
import 'package:chord_list_app/shared/template/c_scale_button.dart';
import 'package:flutter_guitar_chord/flutter_guitar_chord.dart';

class ChordGroupRowWidget extends StatelessWidget {
  const ChordGroupRowWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  final ChordWithPositionsModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: context.colorScheme.onPrimary),
          child: Text(
            item.chord.fullName,
            style: context.textTheme.semiBold14.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ).ph16,
        ),
        CScaleButton(
          onTap: onTap,
          child: Container(
            height: 110,
            decoration: BoxDecoration(color: context.colorScheme.surface),
            child: Row(
              children: [
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: item.positions.length,
                    separatorBuilder: (_, _) => SizedBox.shrink(),
                    itemBuilder: (context, index) {
                      final position = item.positions[index];
                      return SizedBox(
                        width: 100,
                        child: FlutterGuitarChord(
                          labelOpenStrings: true,
                          showLabel: false,
                          frets: position.frets,
                          fingers: position.fingers,
                          fingerSize: 8,
                          stringStroke: 0.5,
                          baseFret: position.baseFret,
                          chordName: item.chord.name,
                          stringColor: context.colorScheme.primary,
                          barColor: context.colorScheme.primary,
                          firstFrameColor: AppColors.brandPurple,
                          tabBackgroundColor: AppColors.brandPurple,
                          tabForegroundColor: Colors.transparent,
                          labelColor: context.colorScheme.secondary,
                          mutedColor: context.colorScheme.secondary,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.chevron_right,
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
