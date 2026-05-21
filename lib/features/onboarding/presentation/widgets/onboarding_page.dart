import 'package:chord_list_app/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:chord_list_app/shared/exports.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.currentPage,
    required this.total,
  });

  final String imagePath;
  final String title;
  final String description;
  final int currentPage;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: MediaQuery.of(context).size.height * 0.5,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: context.textTheme.bold24,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: context.textTheme.regular16,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        PageIndicator(currentPage: currentPage, total: total),
      ],
    );
  }
}
