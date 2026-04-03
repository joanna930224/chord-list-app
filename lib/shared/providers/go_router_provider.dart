import 'package:chord_list_app/core/routes.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();

final goRouterProvider = NotifierProvider<GoRouterNotifier, GoRouter>(
  () => GoRouterNotifier(),
);

class GoRouterNotifier extends Notifier<GoRouter> {
  @override
  GoRouter build() {
    return GoRouter(
      routes: ROUTES,
      initialLocation: '/',
      navigatorKey: navigatorState,
      observers: [],
      errorBuilder: (context, state) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('페이지를 찾을 수 없습니다.', textAlign: TextAlign.center),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: Text('홈으로 이동하기'),
            ),
          ],
        ),
      ),
    );
  }
}
