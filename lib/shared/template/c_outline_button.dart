import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/haptic_provider.dart';

class COutlineButton extends ConsumerWidget {
  const COutlineButton({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: context.textTheme.regular14.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
