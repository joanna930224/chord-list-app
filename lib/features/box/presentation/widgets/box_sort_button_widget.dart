import 'package:chord_list_app/features/box/application/box_view_model_provider.dart';
import 'package:chord_list_app/shared/data/db/dao/box_dao.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/haptic_provider.dart';

class BoxSortButtonWidget extends ConsumerWidget {
  const BoxSortButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortType = ref
        .watch(boxViewModelProvider)
        .value
        ?.sortType ?? BoxSortType.createdAtDesc;

    return GestureDetector(
      onTap: () => _showSortOptions(context, ref, sortType),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sortType.label,
            style: context.textTheme.medium13.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            Icons.unfold_more,
            size: 16,
            color: context.colorScheme.onSurface,
          ),
        ],
      ),
    );
  }

  void _showSortOptions(
    BuildContext context,
    WidgetRef ref,
    BoxSortType current,
  ) {
    final hapticService = ref.read(hapticProvider);

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: BoxSortType.values.map((type) {
              final isSelected = type == current;
              return ListTile(
                title: Text(
                  type.label,
                  style: context.textTheme.regular14.copyWith(
                    color: isSelected
                        ? context.colorScheme.primary
                        : context.colorScheme.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: context.colorScheme.primary)
                    : null,
                onTap: () {
                  hapticService.light();
                  ref
                      .read(boxViewModelProvider.notifier)
                      .changeSortType(type);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

extension _BoxSortTypeLabel on BoxSortType {
  String get label => switch (this) {
    BoxSortType.createdAtDesc => '최근 생성순',
    BoxSortType.createdAtAsc => '오래된 생성순',
    BoxSortType.titleAsc => '제목 ㄱ→ㅎ / A→Z',
    BoxSortType.titleDesc => '제목 ㅎ→ㄱ / Z→A',
  };
}
