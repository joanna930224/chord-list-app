import 'package:chord_list_app/features/library/application/library_view_model_provider.dart';
import 'package:chord_list_app/features/library/presentation/widgets/root_selector_widget.dart';
import 'package:chord_list_app/features/library/presentation/widgets/type_selector_widget.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/chord_root.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryViewModelProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) => SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 코드명 타이틀
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  '${data.selectedRoot.dbKey} ${data.selectedType.dbKey}',
                  style: context.textTheme.bold20.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
              // 루트 셀렉터
              const RootSelectorWidget(),
              const SizedBox(height: 8),
              // 타입 셀렉터 (임시 — Phase 5에서 그리드와 분할 레이아웃으로 교체)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TypeSelectorWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
