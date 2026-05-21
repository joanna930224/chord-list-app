// ignore_for_file: non_constant_identifier_names

import 'package:chord_list_app/features/box/presentation/screens/box_detail_screen.dart';
import 'package:chord_list_app/features/home/presentation/screens/home_screen.dart';
import 'package:chord_list_app/features/my/presentation/screens/theme_mode_setting_screen.dart';
import 'package:chord_list_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:chord_list_app/features/search/presentation/screens/chord_detail_screen.dart';
import 'package:chord_list_app/features/splash/presentation/splash_screen.dart';
import 'package:chord_list_app/shared/template/c_web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> ROUTES = [
  GoRoute(
    path: '/',
    name: SplashScreen.routeName,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: SplashScreen()),
  ),
  GoRoute(
    path: '/onboarding',
    name: OnboardingScreen.routeName,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: OnboardingScreen()),
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
  GoRoute(
    path: '/box/:id',
    name: BoxDetailScreen.routeName,
    builder: (context, state) =>
        BoxDetailScreen(boxId: int.parse(state.pathParameters['id']!)),
  ),
  GoRoute(
    path: '/chord/:id',
    name: ChordDetailScreen.routeName,
    builder: (context, state) =>
        ChordDetailScreen(chordId: int.parse(state.pathParameters['id']!)),
  ),
  GoRoute(
    path: '/webview',
    name: CWebViewScreen.routeName,
    builder: (context, state) => CWebViewScreen(
      title: state.uri.queryParameters['title'] ?? '',
      url: state.uri.queryParameters['url'] ?? '',
    ),
  ),
  GoRoute(
    path: '/licenses',
    name: 'licenses',
    builder: (_, _) => const LicensePage(),
  ),
];
