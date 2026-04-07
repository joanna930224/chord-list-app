import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/theme_provider.dart';
import 'package:chord_list_app/shared/template/c_image.dart';
import 'package:chord_list_app/shared/template/c_list_tile.dart';
import 'package:chord_list_app/shared/template/c_scaffold.dart';
import 'package:chord_list_app/shared/template/future_value_widget.dart';

class ThemeModeSettingScreen extends HookConsumerWidget {
  static String get routeName => '13a2a46b-b030-4783-846c-3b624a616ff8';
  const ThemeModeSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureValueWidget(
      ref.watch(themeProvider.future),
      data: (data) {
        return CScaffold(
          title: Text('화면 설정'),
          body: Column(
            children: [
              _ThemeModeButton(
                title: '밝은 모드',
                onTap: () {
                  ref.read(themeProvider.notifier).setLight();
                },
                isSelected: data == AppThemeMode.light,
              ),
              _ThemeModeButton(
                title: '어두운 모드',
                onTap: () {
                  ref.read(themeProvider.notifier).setDark();
                },
                isSelected: data == AppThemeMode.dark,
              ),
              _ThemeModeButton(
                title: '시스템 설정에 따름',
                onTap: () {
                  ref.read(themeProvider.notifier).setSystem();
                },
                isSelected: data == AppThemeMode.system,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton({
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return CListTile.custom(
      trailing: isSelected
          ? CImage(
              'assets/icons/check_white.svg',
              width: 24,
              height: 24,
              color: AppColors.brandPurple,
            )
          : SizedBox.shrink(),
      title: title,
      onTap: onTap,
    );
  }
}
