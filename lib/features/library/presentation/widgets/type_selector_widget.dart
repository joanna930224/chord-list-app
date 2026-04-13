import 'package:chord_list_app/features/library/application/library_view_model_provider.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';
import 'package:chord_list_app/shared/providers/notation_style_provider.dart';
import 'package:chord_list_app/shared/template/c_flat_button.dart';

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
          final label = switch (notationStyle) {
            ChordNotationStyle.symbol => type.symbolNotation,
            ChordNotationStyle.text => type.textNotation,
          };
          return CFlatButton(
            label: label,
            isSelected: type == selectedType,
            onTap: () =>
                ref.read(libraryViewModelProvider.notifier).selectType(type),
          );
        }).toList(),
      ),
    );
  }
}
