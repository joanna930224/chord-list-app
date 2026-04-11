import 'package:chord_list_app/features/library/application/library_view_model_provider.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';
import 'package:chord_list_app/shared/providers/notation_style_provider.dart';

class TypeSelectorWidget extends ConsumerWidget {
  const TypeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryViewModelProvider).value;
    final types = state?.types ?? [];
    final selectedType = state?.selectedType;
    final notationStyle =
        ref.watch(notationStyleProvider).value ?? ChordNotationStyle.symbol;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: types.map((type) {
          final isSelected = type == selectedType;
          final label = switch (notationStyle) {
            ChordNotationStyle.symbol => type.symbolNotation,
            ChordNotationStyle.text => type.textNotation,
          };
          return _TypeButton(
            label: label,
            isSelected: isSelected,
            onTap: () =>
                ref.read(libraryViewModelProvider.notifier).selectType(type),
          );
        }).toList(),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
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
