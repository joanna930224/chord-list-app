import 'package:chord_list_app/shared/models/chord_type.dart';
import 'package:chord_list_app/shared/providers/preference_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final notationStyleProvider =
    AsyncNotifierProvider<NotationStyleNotifier, ChordNotationStyle>(
      NotationStyleNotifier.new,
    );

class NotationStyleNotifier extends AsyncNotifier<ChordNotationStyle> {
  @override
  Future<ChordNotationStyle> build() async {
    final prefs = ref.read(preferenceRepositoryProvider);
    return prefs.findNotationStyle();
  }

  Future<void> toggle() async {
    final current = state.value ?? ChordNotationStyle.symbol;
    final next = switch (current) {
      ChordNotationStyle.symbol => ChordNotationStyle.text,
      ChordNotationStyle.text => ChordNotationStyle.symbol,
    };
    state = AsyncData(next);
    await ref.read(preferenceRepositoryProvider).saveNotationStyle(next);
  }
}
