import 'package:chord_list_app/features/my/presentation/screens/theme_mode_setting_screen.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_list_tile.dart';

class MyScreen extends StatelessWidget {
  static String get routeName => '3aff611b-d6c9-49f5-818f-f0451e8db532';
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CListTile.arrow(
            title: '화면 테마',
            onTap: () => context.pushNamed(ThemeModeSettingScreen.routeName),
          ),
        ],
      ),
    );
  }
}
