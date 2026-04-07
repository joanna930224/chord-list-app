import 'dart:async';

import 'package:chord_list_app/features/home/presentation/screens/home_screen.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/hooks/use_mount_effect.dart';
import 'package:chord_list_app/shared/template/c_image.dart';

class SplashScreen extends HookConsumerWidget {
  static String get routeName => 'c0758af4-fde4-4ff9-8d1c-48b13b370425';
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final timer = Timer(const Duration(seconds: 2), () {
        if (!context.mounted) return;
        context.goNamed(HomeScreen.routeName);
      });

      return () => timer.cancel();
    }, []);

    return const _Splash();
  }
}

class _Splash extends HookConsumerWidget {
  const _Splash();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogo = useState(false);
    final isTitle = useState(false);

    useMountEffect(() {
      final logoTimer = Timer(const Duration(milliseconds: 100), () {
        isLogo.value = true;
      });

      final titleTimer = Timer(const Duration(milliseconds: 1000), () {
        isTitle.value = true;
      });

      return () {
        logoTimer.cancel();
        titleTimer.cancel();
      };
    }, []);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.brandPurple, AppColors.brandDeepPurple],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: isLogo.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1000),
              child: CImage('assets/icons/chordmap_icon.svg', width: 100),
            ),
            SizedBox(height: 20),
            Center(
              child: AnimatedOpacity(
                opacity: isTitle.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                child: CImage('assets/icons/chordmap_logo.svg', width: 200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
