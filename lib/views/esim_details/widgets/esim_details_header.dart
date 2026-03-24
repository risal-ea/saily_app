import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/esim_details_viewmodel.dart';

/// The top visual header of the eSIM Details page.
/// Displays a large chip graphic and the main data usage metric.
class EsimDetailsHeader extends StatelessWidget {
  const EsimDetailsHeader({super.key, required this.vm});

  final EsimDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    final esim = vm.esim;
    final gradientColors = esim.gradientColors.map((c) => Color(c)).toList();
    final icon = IconData(esim.iconCodePoint, fontFamily: 'MaterialIcons');

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 16, bottom: 32, left: 24, right: 24),
      child: Column(
        children: [
          // Large Chip Graphic
          _chipGraphic(gradientColors, icon),
          const SizedBox(height: 32),
          
          // Data Usage Summary
          const Text(
            'Remaining Data',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                esim.isActive ? '1.2' : '0.0', // Mock calculation
                style: const TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textBlack,
                  letterSpacing: -1.5,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'GB',
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: esim.isActive ? 0.3 : 1.0, // Mock calculation
              minHeight: 10,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                esim.isActive ? AppColors.homeGradientStart : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Expiry text
          Text(
            esim.isActive ? 'Valid until Dec 31, 2026' : 'Plan has expired',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: esim.isActive ? AppColors.textGrey : const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipGraphic(List<Color> gradientColors, IconData icon) {
    return Container(
      width: 220,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 20,
            child: Icon(icon, size: 32, color: Colors.white),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    'SAILY PLAN',
                    style: TextStyle(
                      fontFamily: 'Fustat',
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
