import 'package:chord_list_app/features/library/application/library_state.dart';
import 'package:chord_list_app/features/library/application/library_view_model_provider.dart';
import 'package:chord_list_app/features/library/domain/models/save_chord_action_type.dart';
import 'package:chord_list_app/features/library/presentation/widgets/chord_bottom_sheet_widget.dart';
import 'package:chord_list_app/features/library/presentation/widgets/chord_notation_toggle.dart';
import 'package:chord_list_app/shared/widgets/chord_position_card_widget.dart';
import 'package:chord_list_app/features/library/presentation/widgets/new_box_dialog.dart';
import 'package:chord_list_app/features/library/presentation/widgets/root_selector_widget.dart';
import 'package:chord_list_app/features/library/presentation/widgets/select_box_bottom_sheet_widget.dart';
import 'package:chord_list_app/features/library/presentation/widgets/type_selector_widget.dart';
import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/models/chord_root.dart';
import 'package:chord_list_app/shared/models/chord_type.dart';
import 'package:chord_list_app/shared/providers/notation_style_provider.dart';
import 'package:chord_list_app/shared/template/c_bottom_sheet.dart';
import 'package:chord_list_app/shared/template/c_toast.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryViewModelProvider);
    final notationStyle =
        ref.watch(notationStyleProvider).value ?? ChordNotationStyle.symbol;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) => _LibraryBody(data: data, notationStyle: notationStyle),
      ),
    );
  }
}

class _LibraryBody extends StatelessWidget {
  const _LibraryBody({required this.data, required this.notationStyle});

  final LibraryState data;
  final ChordNotationStyle notationStyle;

  @override
  Widget build(BuildContext context) {
    final cards = data.chordPositions
        .expand(
          (cwp) => cwp.positions.map((p) => (chord: cwp.chord, position: p)),
        )
        .toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${data.selectedRoot.dbKey} ${data.selectedType.fullName}',
                    style: context.textTheme.bold20.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ),
                ChordNotationToggle(current: notationStyle),
              ],
            ),
          ),
          const RootSelectorWidget(),
          const SizedBox(height: 4),
          const Divider(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 84, child: const TypeSelectorWidget()),
                VerticalDivider(width: 1),
                Expanded(
                  child: _ChordPositionGrid(
                    cards: cards,
                    onCardTap: (chord, position) =>
                        _handleCardTap(context, chord, position),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCardTap(
    BuildContext context,
    Chord chord,
    ChordPosition position,
  ) async {
    final action = await showCBottomSheet<SaveChordActionType>(
      context: context,
      builder: (_) => ChordBottomSheetWidget(chord: chord, position: position),
    );
    if (!context.mounted) return;

    switch (action) {
      case SaveChordActionType.createNew:
        _showNewBoxDialog(context, chord, position);
      case SaveChordActionType.addToExisting:
        _showSelectBoxSheet(context, chord, position);
      case null:
        break;
    }
  }

  void _showSelectBoxSheet(
    BuildContext context,
    Chord chord,
    ChordPosition position,
  ) {
    showCBottomSheet<void>(
      context: context,
      builder: (_) => SelectBoxBottomSheetWidget(
        chordPositionId: position.id,
        onSuccess: (title) {
          if (context.mounted) CToast.show(context, '$title에 저장되었습니다.');
        },
        onError: () {
          if (context.mounted) CToast.show(context, '오류가 발생하였습니다.');
        },
        onCreateNew: () {
          if (context.mounted) _showNewBoxDialog(context, chord, position);
        },
      ),
    );
  }

  void _showNewBoxDialog(
    BuildContext context,
    Chord chord,
    ChordPosition position,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => NewBoxDialog(
        chordPositionId: position.id,
        onSuccess: (title) {
          Navigator.pop(dialogCtx);
          if (context.mounted) {
            CToast.show(context, '$title에 저장되었습니다.');
          }
        },
        onError: () {
          if (context.mounted) {
            CToast.show(context, '오류가 발생하였습니다.');
          }
        },
      ),
    );
  }
}

class _ChordPositionGrid extends StatelessWidget {
  const _ChordPositionGrid({required this.cards, required this.onCardTap});

  final List<({Chord chord, ChordPosition position})> cards;
  final void Function(Chord, ChordPosition) onCardTap;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Center(
        child: Text(
          '운지법 없음',
          style: context.textTheme.regular14.copyWith(
            color: context.colorScheme.secondary,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final item = cards[index];
        return ChordPositionCardWidget(
          chord: item.chord,
          position: item.position,
          onTap: () => onCardTap(item.chord, item.position),
        );
      },
    );
  }
}
