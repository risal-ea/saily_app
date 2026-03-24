import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';
import 'package:saily_app/data/models/esim_model.dart';

class QuickBuyBottomSheet extends StatelessWidget {
  final ESimModel activeEsim;
  final String dataLabel;
  final String priceLabel;
  final double gigabytes;

  const QuickBuyBottomSheet({
    super.key,
    required this.activeEsim,
    required this.dataLabel,
    required this.priceLabel,
    required this.gigabytes,
  });

  @override
  Widget build(BuildContext context) {
    // Theme colors matching active eSIM
    final primaryColor = Color(activeEsim.gradientColors.first);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Close button
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColors.textBlack),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(height: 8),

          // Title
          const Text(
            'Confirm Purchase',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textBlack,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Top up your active ${activeEsim.subtitle} plan',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Fustat',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 40),

          // Plan Details Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.homeBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add-on Data',
                      style: TextStyle(
                        fontFamily: 'Fustat',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dataLabel,
                      style: const TextStyle(
                        fontFamily: 'Fustat',
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBlack,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    priceLabel,
                    style: TextStyle(
                      fontFamily: 'Fustat',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // Buy Now Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.read<HomeViewModel>().buyDataPlan(gigabytes);
                Navigator.of(context).pop();
                
                // Optional: Show success snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully added $dataLabel to ${activeEsim.title}'),
                    backgroundColor: const Color(0xFF22C55E),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
