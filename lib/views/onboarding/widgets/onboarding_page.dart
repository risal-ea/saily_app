import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color backgroundColor;
  final CrossAxisAlignment textAlignment;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.backgroundColor,
    this.textAlignment = CrossAxisAlignment.start,
  });

  TextAlign get _textAlign {
    switch (textAlignment) {
      case CrossAxisAlignment.end:
        return TextAlign.right;
      case CrossAxisAlignment.center:
        return TextAlign.center;
      default:
        return TextAlign.left;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: textAlignment,
            children: [
              SizedBox(height: screenHeight * 0.06),

              // Large bold title
              Text(
                title,
                textAlign: _textAlign,
                style: const TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onboardingTitle,
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 14),

              // Subtitle
              Text(
                subtitle,
                textAlign: _textAlign,
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onboardingTitle,
                  height: 1.5,
                ),
              ),

              // const Spacer(),

              // Illustration — centered in remaining space
              Expanded(
                flex: 3,
                child: Center(
                  child: Image.asset(
                    imagePath,
                    height: screenHeight * 0.48,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Extra bottom padding so image clears the overlay (dots + button)
              SizedBox(height: screenHeight * 0.18),
            ],
          ),
        ),
      ),
    );
  }
}
