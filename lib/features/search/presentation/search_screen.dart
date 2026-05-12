import 'package:chord_list_app/features/search/application/search_state.dart';
import 'package:chord_list_app/features/search/application/search_view_model_provider.dart';
import 'package:chord_list_app/features/search/presentation/screens/chord_detail_screen.dart';
import 'package:chord_list_app/features/search/presentation/widgets/chord_group_row_widget.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/chord_with_positions_model.dart';
import 'package:flutter/cupertino.dart';

class SearchScreen extends HookConsumerWidget {
  static String get routeName => '235553d7-43be-455e-ad9c-358418343565';
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchViewModelProvider);
    final controller = useTextEditingController();

    useEffect(() {
      void listener() {
        ref.read(searchViewModelProvider.notifier).search(controller.text);
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Search',
              style: context.textTheme.bold20.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ).ph16,
            SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: '코드 검색',
                prefixIcon: const Icon(CupertinoIcons.search),
                fillColor: context.colorScheme.surfaceContainerHighest,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.brandPurple,
                    width: 1.0,
                  ),
                ),
              ),
            ).ph16,
            SizedBox(height: 20),
            Expanded(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(e.toString())),
                data: (data) => _SearchBody(
                  data: data,
                  onChordTap: (item) async {
                    await context.pushNamed(
                      ChordDetailScreen.routeName,
                      pathParameters: {'id': item.chord.id.toString()},
                    );
                    if (context.mounted) {
                      await ref
                          .read(searchViewModelProvider.notifier)
                          .refreshRecent();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({required this.data, required this.onChordTap});

  final SearchState data;
  final Future<void> Function(ChordWithPositionsModel) onChordTap;

  @override
  Widget build(BuildContext context) {
    final showRecent = data.recentChords.isNotEmpty && data.query.isEmpty;
    final chords = data.filteredChords;

    if (!showRecent && chords.isEmpty) {
      return Center(
        child: Text(
          '검색 결과가 없습니다.',
          style: context.textTheme.regular14.copyWith(
            color: context.colorScheme.secondary,
          ),
        ),
      );
    }

    return ListView(
      children: [
        if (showRecent) ...[
          _SectionTitle(title: '최근 검색한 코드'),
          ...data.recentChords.map(
            (item) => ChordGroupRowWidget(
              item: item,
              onTap: () {
                onChordTap(item);
              },
            ),
          ),
        ] else ...[
          ...chords.map(
            (item) => ChordGroupRowWidget(
              item: item,
              onTap: () {
                onChordTap(item);
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: context.textTheme.bold20.copyWith(
          color: context.colorScheme.onSurface,
        ),
      ),
    );
  }
}
