import 'package:chord_list_app/features/box/domain/models/chord_box_model.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_scale_button.dart';
import 'package:intl/intl.dart';

class BoxListTileWidget extends StatelessWidget {
  const BoxListTileWidget({super.key, required this.box, required this.onTap});

  final ChordBoxModel box;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return CScaleButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 24,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    box.title,
                    style: context.textTheme.semiBold14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (box.description != null &&
                      box.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      box.description!,
                      style: context.textTheme.regular12.copyWith(
                        color: colorScheme.outline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        DateFormat(
                          'yyyy.MM.dd',
                        ).format(box.createdAt.toLocal()),
                        style: context.textTheme.regular12.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.outline, size: 20),
          ],
        ),
      ),
    );
  }
}
