import 'package:chord_list_app/core/theme.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/go_router_provider.dart';
import 'package:chord_list_app/shared/providers/theme_provider.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeAsync = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light(context),
      darkTheme: AppTheme.dark(context),
      themeMode: themeAsync.when(
        data: (themeMode) => switch (themeMode) {
          AppThemeMode.light => ThemeMode.light,
          AppThemeMode.dark => ThemeMode.dark,
          AppThemeMode.system => ThemeMode.system,
        },
        loading: () => ThemeMode.system,
        error: (error, stackTrace) => ThemeMode.system,
      ),
    );
  }
}
