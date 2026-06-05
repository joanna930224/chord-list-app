import 'package:chord_list_app/shared/exports.dart';

const int _stringCount = 6;
const int _fretCount = 5;
const _fingerOptions = ['T', '1', '2', '3', '4'];
const _loopMultiplier = 500;
const double _fretRowHeight = 44.0;
const double _leftColumnWidth = 28.0;
const int _minBaseFret = 1;
const int _maxBaseFret = 12;

class FretboardWidget extends StatelessWidget {
  const FretboardWidget({
    super.key,
    required this.frets,
    required this.baseFret,
    required this.fingers,
    required this.onFretSelected,
    required this.onMuteToggled,
    required this.onFingerChanged,
    required this.onBaseFretChanged,
    this.onDialChanged,
  });

  final List<int> frets;
  final int baseFret;
  final List<String> fingers;
  final void Function(int stringIndex, int fret) onFretSelected;
  final void Function(int stringIndex) onMuteToggled;
  final void Function(int stringIndex, String finger) onFingerChanged;
  final void Function(int newBaseFret) onBaseFretChanged;
  final VoidCallback? onDialChanged;

  @override
  Widget build(BuildContext context) {
    final outlineColor = context.colorScheme.outline;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 프렛 번호 설정
          _BaseFretControl(
            baseFret: baseFret,
            onChanged: onBaseFretChanged,
            onHaptic: onDialChanged,
          ),
          Expanded(
            child: Column(
              children: [
                // 뮤트/오픈 토글
                Row(
                  children: List.generate(_stringCount, (s) {
                    final isMuted = frets[s] == -1;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onMuteToggled(s),
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: Text(
                            isMuted ? 'X' : 'O',
                            style: context.textTheme.semiBold16.copyWith(
                              color: isMuted
                                  ? context.colorScheme.error
                                  : outlineColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 4),
                // 프렛 격자
                ...List.generate(_fretCount, (row) {
                  final fretNumber = row + 1;
                  return Row(
                    children: List.generate(_stringCount, (s) {
                      final isSelected = frets[s] == fretNumber;
                      final isMuted = frets[s] == -1;
                      return Expanded(
                        child: GestureDetector(
                          onTap: isMuted
                              ? null
                              : () => onFretSelected(
                                  s,
                                  isSelected ? 0 : fretNumber,
                                ),
                          child: Container(
                            height: _fretRowHeight,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: outlineColor.withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                              color: isMuted
                                  ? context.colorScheme.surface.withValues(
                                      alpha: 0.4,
                                    )
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: const BoxDecoration(
                                        color: AppColors.brandPurple,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),
                  );
                }),
                const SizedBox(height: 8),
                // 손가락 번호 다이얼
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(_stringCount, (s) {
                    final isEnabled = frets[s] > 0;
                    final currentFinger = fingers[s] == '0' ? '1' : fingers[s];
                    return Expanded(
                      child: _FingerWheelColumn(
                        key: ValueKey('wheel_$s'),
                        currentFinger: currentFinger,
                        isEnabled: isEnabled,
                        onChanged: (f) => onFingerChanged(s, f),
                        onHaptic: onDialChanged,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BaseFretControl extends StatelessWidget {
  const _BaseFretControl({
    required this.baseFret,
    required this.onChanged,
    this.onHaptic,
  });

  final int baseFret;
  final void Function(int) onChanged;
  final VoidCallback? onHaptic;

  @override
  Widget build(BuildContext context) {
    final activeColor = context.colorScheme.onSurface;
    final disabledColor = context.colorScheme.onSurface.withValues(alpha: 0.2);

    return SizedBox(
      width: _leftColumnWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: baseFret > _minBaseFret
                ? () {
                    onHaptic?.call();
                    onChanged(baseFret - 1);
                  }
                : null,
            child: Icon(
              Icons.arrow_drop_up,
              size: 32,
              color: baseFret > _minBaseFret ? activeColor : disabledColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$baseFret',
            style: context.textTheme.semiBold18.copyWith(color: activeColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: baseFret < _maxBaseFret
                ? () {
                    onHaptic?.call();
                    onChanged(baseFret + 1);
                  }
                : null,
            child: Icon(
              Icons.arrow_drop_down,
              size: 32,
              color: baseFret < _maxBaseFret ? activeColor : disabledColor,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _FingerWheelColumn extends HookWidget {
  const _FingerWheelColumn({
    super.key,
    required this.currentFinger,
    required this.isEnabled,
    required this.onChanged,
    this.onHaptic,
  });

  final String currentFinger;
  final bool isEnabled;
  final void Function(String finger) onChanged;
  final VoidCallback? onHaptic;

  @override
  Widget build(BuildContext context) {
    final initialIndex = _fingerOptions.indexOf(currentFinger);
    final controller = useMemoized(
      () => FixedExtentScrollController(
        initialItem:
            _fingerOptions.length * _loopMultiplier +
            (initialIndex < 0 ? 0 : initialIndex),
      ),
    );
    useEffect(() => controller.dispose, const []);

    final lastReportedFinger = useRef(currentFinger);

    useEffect(() {
      if (currentFinger != lastReportedFinger.value) {
        final newIndex = _fingerOptions.indexOf(currentFinger);
        if (newIndex >= 0) {
          final current = controller.selectedItem;
          final remainder = current % _fingerOptions.length;
          final diff = newIndex - remainder;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (controller.hasClients) controller.jumpToItem(current + diff);
          });
        }
        lastReportedFinger.value = currentFinger;
      }
      return null;
    }, [currentFinger]);

    final outlineColor = context.colorScheme.outline;
    final textColor = isEnabled
        ? context.colorScheme.onSurface
        : context.colorScheme.onSurface.withValues(alpha: 0.25);

    return SizedBox(
      height: 84,
      child: Stack(
        children: [
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 28,
            physics: isEnabled
                ? const FixedExtentScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            perspective: 0.003,
            diameterRatio: 1.5,
            magnification: 1.3,
            useMagnifier: true,
            overAndUnderCenterOpacity: 0.4,
            onSelectedItemChanged: (i) {
              if (!isEnabled) return;
              onHaptic?.call();
              final finger = _fingerOptions[i % _fingerOptions.length];
              lastReportedFinger.value = finger;
              onChanged(finger);
            },
            childDelegate: ListWheelChildLoopingListDelegate(
              children: _fingerOptions
                  .map(
                    (f) => Center(
                      child: Text(
                        f,
                        style: context.textTheme.semiBold16.copyWith(
                          color: textColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              Divider(
                height: 0.5,
                thickness: 0.5,
                color: outlineColor.withValues(alpha: isEnabled ? 0.5 : 0.2),
              ),
              const Spacer(),
              Divider(
                height: 0.5,
                thickness: 0.5,
                color: outlineColor.withValues(alpha: isEnabled ? 0.5 : 0.2),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
