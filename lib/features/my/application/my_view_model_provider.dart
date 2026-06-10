import 'package:chord_list_app/features/my/application/my_state.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/haptic_provider.dart';
import 'package:chord_list_app/shared/providers/package_info_provider.dart';
import 'package:chord_list_app/shared/providers/preference_provider.dart';

final myViewModelProvider =
    AsyncNotifierProvider.autoDispose<MyViewModelNotifier, MyState>(
      MyViewModelNotifier.new,
    );

class MyViewModelNotifier extends AsyncNotifier<MyState> {
  @override
  Future<MyState> build() async {
    final (isHaptic, packageInfo) = await (
      ref.read(preferenceRepositoryProvider).findHaptic(),
      ref.read(packageInfoProvider.future),
    ).wait;
    return MyState(
      isHaptic: isHaptic,
      appVersion: '${packageInfo.version} (${packageInfo.buildNumber})',
    );
  }

  void setHaptic(bool value) async {
    final hapticService = ref.read(hapticProvider);
    await hapticService.selection();
    state = AsyncValue.data(state.value!.copyWith(isHaptic: value));
    await ref.read(preferenceRepositoryProvider).saveHaptic(value);
  }
}
