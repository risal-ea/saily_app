import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';
import 'package:saily_app/views/home/widgets/esim_card_item.dart';
import 'package:saily_app/views/esim_list/all_esims_screen.dart';

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
              if (vm.eSims.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllEsimsScreen()),
                    );
                  },
                  child: const Text(
                    'All',
                    style: TextStyle(
                      fontFamily: 'Fustat',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (vm.eSims.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.sim_card_alert_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No eSIMs available',
                    style: TextStyle(
                      fontFamily: 'Fustat',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your purchased plans will appear here.',
                    style: TextStyle(
                      fontFamily: 'Fustat',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
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
