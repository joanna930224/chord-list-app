import 'package:chord_list_app/features/home/presentation/screens/home_screen.dart';
import 'package:chord_list_app/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/hooks/use_mount_effect.dart';
import 'package:chord_list_app/shared/providers/preference_provider.dart';
import 'package:chord_list_app/shared/template/c_elevated_button.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends HookConsumerWidget {
  static String get routeName => 'onboarding';
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);
    const total = 4;

    useMountEffect(() {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      return () => SystemChrome.setPreferredOrientations([]);
    }, []);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.brandPurple, Colors.black12],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (index) => currentPage.value = index,
                    children: [
                      OnboardingPage(
                        imagePath: 'assets/images/onboarding_1.webp',
                        title: '코드 라이브러리',
                        description: '다양한 기타 코드의 운지법을\n한눈에 확인하세요.',
                        currentPage: currentPage.value,
                        total: total,
                      ),
                      OnboardingPage(
                        imagePath: 'assets/images/onboarding_2.webp',
                        title: '빠른 코드 검색',
                        description: '원하는 코드를 빠르게 검색하고\n바로 연습해보세요.',
                        currentPage: currentPage.value,
                        total: total,
                      ),
                      OnboardingPage(
                        imagePath: 'assets/images/onboarding_3.webp',
                        title: '나만의 보관함',
                        description: '자주 쓰는 코드를 Box에 저장하고\n한 번에 모아보세요.',
                        currentPage: currentPage.value,
                        total: total,
                      ),
                      OnboardingPage(
                        imagePath: 'assets/images/onboarding_4.webp',
                        title: '커스텀 코드',
                        description: '내 손에 맞는 운지법으로\n직접 만들어 보세요.',
                        currentPage: currentPage.value,
                        total: total,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                  child: SizedBox(
                    width: double.infinity,
                    child: currentPage.value < total - 1
                        ? CElevatedButton(
                            onPressed: () {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            title: '다음',
                          )
                        : CElevatedButton(
                            onPressed: () async {
                              await ref
                                  .read(preferenceRepositoryProvider)
                                  .saveOnboardingDone();
                              if (!context.mounted) return;
                              context.goNamed(HomeScreen.routeName);
                            },
                            title: '시작하기',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
