import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/haptic_provider.dart';

class CFlatButton extends ConsumerWidget {
  const CFlatButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.hapticType = HapticType.selection,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final HapticType hapticType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hapticService = ref.read(hapticProvider);
    final colorScheme = context.colorScheme;

    return GestureDetector(
      onTap: () {
        hapticService.feedback(hapticType);
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
        ),
        child: Text(
          label,
          style: context.textTheme.regular13.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
