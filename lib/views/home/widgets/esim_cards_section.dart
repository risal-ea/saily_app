import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';
import 'package:saily_app/views/home/widgets/esim_card_item.dart';

/// "Your eSIMs" horizontal carousel section.
class ESimCardsSection extends StatelessWidget {
  const ESimCardsSection({super.key, required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your eSIMs',
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textBlack,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'All',
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children:
                vm.eSims.map((esim) => ESimCardItem(esim: esim)).toList(),
          ),
        ),
      ],
    );
  }
}
