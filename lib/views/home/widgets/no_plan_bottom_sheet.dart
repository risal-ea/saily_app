import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/views/data_plans/data_plans_screen.dart';

class NoPlanBottomSheet extends StatelessWidget {
  const NoPlanBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Illustration/Icon Area
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF4F0FF), Color(0xFFEBE5FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.homeGradientStart.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.signal_wifi_off,
                size: 36,
                color: AppColors.homeGradientStart,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Text Content
          const Text(
            'Activation Required',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textBlack,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'You need an active eSIM data plan to use VPN, Ad Blocking, and Web Protection features. Get a plan to secure your connection instantly.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),

          // Explore Plans Button
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DataPlansScreen(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.homeGradientStart, AppColors.homeGradientEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.homeGradientStart.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Explore Plans',
                  style: TextStyle(
                    fontFamily: 'Fustat',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Cancel 'Button'
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textGrey,
            ),
            child: const Text(
              'Not Now',
              style: TextStyle(
                fontFamily: 'Fustat',
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
