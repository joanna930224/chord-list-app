import 'package:chord_list_app/features/library/application/library_view_model_provider.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/chord_root.dart';

class RootSelectorWidget extends ConsumerWidget {
  const RootSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoot = ref
        .watch(libraryViewModelProvider)
        .value
        ?.selectedRoot;

    return SizedBox(
      height: 44,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          spacing: 8,
          children: ChordRoot.values.map((root) {
            final isSelected = root == selectedRoot;
            return _RootButton(
              label: root.label,
              isSelected: isSelected,
              onTap: () => ref
                  .read(libraryViewModelProvider.notifier)
                  .selectRoot(root),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _RootButton extends StatelessWidget {
  const _RootButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
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
