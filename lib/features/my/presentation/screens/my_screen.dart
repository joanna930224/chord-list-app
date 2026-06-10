import 'package:chord_list_app/features/my/application/my_view_model_provider.dart';
import 'package:chord_list_app/features/my/presentation/screens/theme_mode_setting_screen.dart';
import 'package:chord_list_app/shared/constant.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_list_tile.dart';
import 'package:chord_list_app/shared/template/c_web_view_screen.dart';
import 'package:chord_list_app/shared/template/future_value_widget.dart';

class MyScreen extends HookConsumerWidget {
  static String get routeName => '3aff611b-d6c9-49f5-818f-f0451e8db532';
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureValueWidget(
      ref.watch(myViewModelProvider.future),
      data: (data) {
        final viewModel = ref.read(myViewModelProvider.notifier);

        return Scaffold(
          backgroundColor: context.colorScheme.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'MY',
                    style: context.textTheme.bold20.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ).ph16,
                  SizedBox(height: 24),
                  Text(
                    '설정',
                    style: context.textTheme.semiBold14.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ).ph16,
                  SizedBox(height: 8),
                  CListTile.arrow(
                    title: '화면 테마',
                    onTap: () =>
                        context.pushNamed(ThemeModeSettingScreen.routeName),
                  ),
                  CListTile.switchToggle(
                    title: '진동',
                    value: data.isHaptic,
                    onChanged: (value) {
                      viewModel.setHaptic(value);
                    },
                  ),
                  SizedBox(height: 20),
                  Divider(color: context.colorScheme.onPrimary),
                  SizedBox(height: 20),
                  Text(
                    '고객 센터',
                    style: context.textTheme.semiBold14.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ).ph16,
                  SizedBox(height: 8),
                  CListTile.arrow(
                    title: '공지사항',
                    onTap: () => context.pushNamed(
                      CWebViewScreen.routeName,
                      queryParameters: {'title': '공지사항', 'url': URL_NOTICE},
                    ),
                  ),
                  CListTile.arrow(
                    title: '문의하기',
                    onTap: () => context.pushNamed(
                      CWebViewScreen.routeName,
                      queryParameters: {'title': '문의하기', 'url': URL_INQUIRY},
                    ),
                  ),
                  CListTile.arrow(
                    title: '이용약관',
                    onTap: () => context.pushNamed(
                      CWebViewScreen.routeName,
                      queryParameters: {'title': '이용약관', 'url': URL_TERMS},
                    ),
                  ),
                  CListTile.arrow(
                    title: '개인정보처리방침',
                    onTap: () => context.pushNamed(
                      CWebViewScreen.routeName,
                      queryParameters: {
                        'title': '개인정보처리방침',
                        'url': URL_PRIVACY,
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(color: context.colorScheme.onPrimary),
                  SizedBox(height: 20),
                  Text(
                    '정보',
                    style: context.textTheme.semiBold14.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ).ph16,
                  SizedBox(height: 8),
                  CListTile.custom(
                    title: '앱 버전',
                    trailing: Text(
                      'v ${data.appVersion}',
                      style: context.textTheme.medium14.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                  CListTile.arrow(
                    title: '오픈소스 라이선스',
                    onTap: () => context.pushNamed('licenses'),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
