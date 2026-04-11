import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';
import 'package:chord_list_app/shared/providers/notation_style_provider.dart';

const _itemWidth = 44.0;
const _itemHeight = 30.0;
const _padding = 2.0;
const _indicatorInset = 2.0;

class ChordNotationToggle extends ConsumerWidget {
  const ChordNotationToggle({super.key, required this.current});

  final ChordNotationStyle current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSymbol = current == ChordNotationStyle.symbol;

    return GestureDetector(
      onTap: () => ref.read(notationStyleProvider.notifier).toggle(),
      child: Container(
        width: _itemWidth * 2 + _padding * 2,
        height: _itemHeight + _padding * 2,
        padding: const EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: context.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: isSymbol ? _indicatorInset : _itemWidth + _indicatorInset,
              top: _indicatorInset,
              width: _itemWidth - _indicatorInset * 2,
              height: _itemHeight - _indicatorInset * 2,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.brandPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            // 라벨
            Row(
              children: [
                _Label(label: '♩', selected: isSymbol),
                _Label(label: 'Aa', selected: !isSymbol),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _itemWidth,
      height: _itemHeight,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: context.textTheme.regular14.copyWith(
            color: selected
                ? AppColors.grey50
                : context.colorScheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
