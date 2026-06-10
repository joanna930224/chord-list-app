import 'package:chord_list_app/features/library/domain/models/save_chord_action_type.dart';
import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_bottom_sheet.dart';
import 'package:chord_list_app/shared/template/c_scale_button.dart';

class ChordBottomSheetWidget extends StatelessWidget {
  const ChordBottomSheetWidget({
    super.key,
    required this.chord,
    required this.position,
  });

  final Chord chord;
  final ChordPosition position;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CBottomSheetHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(chord.fullName, style: context.textTheme.semiBold22),
          ),
          const Divider(height: 1),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.add_box_outlined,
                  label: '새로운 Box 생성',
                  onTap: () => context.pop(SaveChordActionType.createNew),
                ),
              ),
              Expanded(
                child: _ActionButton(
                  icon: Icons.inventory_2_outlined,
                  label: '기존 Box에 추가',
                  onTap: () => context.pop(SaveChordActionType.addToExisting),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CScaleButton(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),

            decoration: BoxDecoration(
              color: context.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.colorScheme.outline,
                width: 0.5,
              ),
            ),
            child: Icon(icon, size: 28, color: context.colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: context.textTheme.regular16,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
