import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/core/routes/app_routes.dart';
import 'package:saily_app/viewmodels/onboarding_viewmodel.dart';
import 'package:saily_app/views/onboarding/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  static const List<Color> _backgroundColors = [
    AppColors.onboarding1Bg,
    AppColors.onboarding2Bg,
    AppColors.onboarding3Bg,
  ];

  static const List<CrossAxisAlignment> _alignments = [
    CrossAxisAlignment.start,
    CrossAxisAlignment.start,
    CrossAxisAlignment.center,
  ];

  final List<Map<String, String>> _pages = const [
    {
      'title': 'Stay\nConnected\nAnywhere',
      'subtitle': 'Get instant data in 200+ countries. No SIM cards. No hassle.',
      'image': 'assets/images/flying.png',
    },
    {
      'title': 'Travel\nWithout\nLimits',
      'subtitle': 'Activate data in seconds, wherever you go. Fast, reliable, and global.',
      'image': 'assets/images/climping.png',
    },
    {
      'title': 'Internet,\nReady When\nYou Land',
      'subtitle': 'Skip roaming fees and physical SIMs. Buy and connect instantly.',
      'image': 'assets/images/on_mobile.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onGetStartedPressed(OnboardingViewModel viewModel) async {
    await viewModel.completeOnboarding();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          // Full-screen PageView — the entire screen slides as one page
          body: Stack(
            children: [
              // Full-screen PageView — no split, one unified sliding surface
              PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: viewModel.setPage,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPage(
                    title: page['title']!,
                    subtitle: page['subtitle']!,
                    imagePath: page['image']!,
                    backgroundColor: _backgroundColors[index],
                    textAlignment: _alignments[index],
                  );
                },
              ),

              // Overlay bottom controls — floats on top of the PageView
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dot indicator
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: _pages.length,
                          effect: const ExpandingDotsEffect(
                            activeDotColor: AppColors.dotActive,
                            dotColor: AppColors.dotInactive,
                            dotHeight: 8,
                            dotWidth: 8,
                            expansionFactor: 4,
                            spacing: 6,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Next / Get Started button
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              if (viewModel.isLastPage) {
                                _onGetStartedPressed(viewModel);
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonBackground,
                              foregroundColor: AppColors.buttonForeground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  viewModel.isLastPage ? 'Get Started' : 'Next',
                                  style: const TextStyle(
                                    fontFamily: 'Fustat',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const Icon(
                                  Icons.double_arrow_rounded,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
