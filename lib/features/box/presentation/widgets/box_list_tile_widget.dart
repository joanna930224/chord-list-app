import 'package:chord_list_app/features/box/domain/models/chord_box_model.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_scale_button.dart';
import 'package:intl/intl.dart';

class BoxListTileWidget extends StatelessWidget {
  const BoxListTileWidget({
    super.key,
    required this.box,
    required this.chordNames,
    required this.onTap,
  });

  final ChordBoxModel box;

  /// 저장된 코드명 목록 (e.g. ['G', 'E', 'Am'])
  final List<String> chordNames;
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
            // 썸네일
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
            // 텍스트 영역
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    box.title,
                    style: context.textTheme.semiBold14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // 설명 (있을 때만)
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
                  // 생성일 + 코드 내역
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
                      if (chordNames.isNotEmpty) ...[
                        Text(
                          '  ·  ',
                          style: context.textTheme.regular12.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            chordNames.join(', '),
                            style: context.textTheme.regular12.copyWith(
                              color: colorScheme.outline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
