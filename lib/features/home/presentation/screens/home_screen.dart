import 'package:chord_list_app/features/home/presentation/screens/theme_mode_setting_screen.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_list_tile.dart';

class HomeScreen extends StatelessWidget {
  static String get routeName => 'ab2def8e-780f-4f5a-94f4-7d3dfc64f47f';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.brandPurple,
        title: Text('HOME'),
      ),
      body: Center(
        child: Column(
          children: [
            CListTile.arrow(
              title: '화면 테마',
              onTap: () => context.pushNamed(ThemeModeSettingScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
