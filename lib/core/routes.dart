// ignore_for_file: non_constant_identifier_names

import 'package:chord_list_app/features/home/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> ROUTES = [
  GoRoute(
    path: '/',
    name: HomeScreen.routeName,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: HomeScreen()),
  ),
];
