import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/bden_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Give blood. Save lives.',
      'body': 'Your donation can be the difference between life and death.',
      'icon': HugeIcons.strokeRoundedDroplet,
    },
    {
      'title': 'Find campaigns near you',
      'body': 'Easily locate blood drives and emergency requests in your area.',
      'icon': HugeIcons.strokeRoundedLocation01,
    },
    {
      'title': 'Every drop counts 💧',
      'body': 'Join a community of lifesavers making a real impact.',
      'icon': HugeIcons.strokeRoundedFavourite,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.donorSetup),
                child: Text('Skip',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.textSecondary)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HugeIcon(
                                icon: page['icon'],
                                size: 120,
                                color: AppColors.primary)
                            .animate()
                            .fadeIn()
                            .scale(),
                        const Gap(48),
                        Text(page['title'],
                                style: AppTextStyles.displayLarge,
                                textAlign: TextAlign.center)
                            .animate()
                            .fadeIn()
                            .slideY(begin: 0.2),
                        const Gap(16),
                        Text(page['body'],
                                style: AppTextStyles.bodyLarge,
                                textAlign: TextAlign.center)
                            .animate()
                            .fadeIn()
                            .slideY(begin: 0.2, delay: 100.ms),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: 300.ms,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const Gap(32),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: BdenButton(
                label:
                    _currentPage == _pages.length - 1 ? 'Get started' : 'Next',
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                        duration: 300.ms, curve: Curves.easeInOut);
                  } else {
                    context.go(AppRoutes.donorSetup);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
