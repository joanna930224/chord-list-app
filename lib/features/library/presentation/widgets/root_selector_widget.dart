import 'package:chord_list_app/features/library/application/library_view_model_provider.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/chord_root.dart';
import 'package:chord_list_app/shared/template/c_outline_button.dart';

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
            return COutlineButton(
              label: root.label,
              isSelected: root == selectedRoot,
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
