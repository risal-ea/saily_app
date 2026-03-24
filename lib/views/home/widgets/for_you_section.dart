import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';
import 'package:saily_app/views/home/widgets/recommendation_card.dart';

/// "For You" smart recommendations section.
/// Cards are driven by [HomeViewModel.forYouCards] — max 3 shown,
/// priority-ordered by the ViewModel's business logic.
class ForYouSection extends StatelessWidget {
  const ForYouSection({super.key, required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'For You',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textBlack,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Smart suggestions based on your activity',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 16),
          ...vm.forYouCards.map(
            (card) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RecommendationCard(card: card),
            ),
          ),
        ],
      ),
    );
  }
}
