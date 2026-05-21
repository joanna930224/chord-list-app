import 'dart:async';

import 'package:chord_list_app/features/home/presentation/screens/home_screen.dart';
import 'package:chord_list_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/hooks/use_mount_effect.dart';
import 'package:chord_list_app/shared/providers/preference_provider.dart';
import 'package:chord_list_app/shared/template/c_image.dart';

class SplashScreen extends HookConsumerWidget {
  static String get routeName => 'c0758af4-fde4-4ff9-8d1c-48b13b370425';
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final timer = Timer(const Duration(milliseconds: 2500), () async {
        if (!context.mounted) return;
        final isDone = await ref.read(preferenceRepositoryProvider).findOnboardingDone();
        if (!context.mounted) return;
        context.goNamed(isDone ? HomeScreen.routeName : OnboardingScreen.routeName);
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
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                const _BoxAnimation(),
                AnimatedOpacity(
                  opacity: isLogo.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 1000),
                  child: CImage('assets/icons/chordbox_icon.svg', width: 100),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: AnimatedOpacity(
                opacity: isTitle.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                child: CImage('assets/icons/chordbox_logo.svg', width: 200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoxAnimation extends HookWidget {
  const _BoxAnimation();

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 800),
    )..forward();

    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: BoxPainter(controller.value),
        );
      },
    );
  }
}

class BoxPainter extends CustomPainter {
  final double t;
  BoxPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    final progress = Curves.easeOut.transform(t);

    final top = w * progress;
    final left = h * progress;
    final right = h * progress;
    final bottom = w * progress;

    canvas.drawLine(Offset(0, 0), Offset(top, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, right), paint);
    canvas.drawLine(Offset(w, h), Offset(w - bottom, h), paint);
    canvas.drawLine(Offset(0, h), Offset(0, h - left), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
