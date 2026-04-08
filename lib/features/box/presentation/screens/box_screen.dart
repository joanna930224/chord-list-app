import 'package:chord_list_app/features/box/presentation/widgets/app_bar.dart';
import 'package:chord_list_app/shared/exports.dart';

class BoxScreen extends HookConsumerWidget {
  const BoxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          BoxAppBar(scrollController: scrollController),

          SliverToBoxAdapter(
            child: Column(
              children: [Placeholder(), Placeholder(), Placeholder()],
            ),
          ),
        ],
      ),
    );
  }
}
