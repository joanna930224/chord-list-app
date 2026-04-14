import 'package:chord_list_app/features/box/application/box_view_model_provider.dart';
import 'package:chord_list_app/features/box/presentation/screens/box_detail_screen.dart';
import 'package:chord_list_app/features/box/presentation/widgets/app_bar.dart';
import 'package:chord_list_app/features/box/presentation/widgets/box_empty_widget.dart';
import 'package:chord_list_app/features/box/presentation/widgets/box_list_tile_widget.dart';
import 'package:chord_list_app/shared/exports.dart';

class BoxScreen extends HookConsumerWidget {
  static String get routeName => '0a7c3f54-ede6-41c1-bda1-167487d0a241';
  const BoxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final boxState = ref.watch(boxViewModelProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          BoxAppBar(scrollController: scrollController),
          boxState.when(
            data: (state) {
              if (state.boxes.isEmpty) {
                return const SliverFillRemaining(child: BoxEmptyWidget());
              }
              return SliverMainAxisGroup(
                slivers: [
                  SliverList.builder(
                    itemCount: state.boxes.length,
                    itemBuilder: (context, index) {
                      final box = state.boxes[index];
                      return BoxListTileWidget(
                        box: box,
                        chordNames: const [], // Phase 3: 코드명은 추후 연동
                        onTap: () => context.pushNamed(
                          BoxDetailScreen.routeName,
                          pathParameters: {'id': box.id.toString()},
                        ),
                      );
                    },
                  ),
                ],
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('오류가 발생했습니다: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
