// ignore_for_file: non_constant_identifier_names

import 'package:chord_list_app/features/home/presentation/screens/home_screen.dart';
import 'package:chord_list_app/features/my/presentation/screens/theme_mode_setting_screen.dart';
import 'package:chord_list_app/features/splash/presentation/splash_screen.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> ROUTES = [
  GoRoute(
    path: '/',
    name: SplashScreen.routeName,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: SplashScreen()),
  ),
  GoRoute(
    path: '/home',
    name: HomeScreen.routeName,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: HomeScreen()),
  ),
  GoRoute(
    path: '/settings/theme-mode',
    name: ThemeModeSettingScreen.routeName,
    builder: (_, _) => const ThemeModeSettingScreen(),
  ),
];
