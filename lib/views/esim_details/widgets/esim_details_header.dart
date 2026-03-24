import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/esim_details_viewmodel.dart';
import 'dart:ui';

/// The top visual header of the eSIM Details page.
/// Displays a highly premium holographic chip graphic and massive data usage metrics.
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
      padding: const EdgeInsets.only(top: 8, bottom: 24, left: 24, right: 24),
      child: Column(
        children: [
          // Premium Holographic Chip Graphic
          _holographicChip(gradientColors, icon, esim),
          const SizedBox(height: 48),
          
          // Data Usage Summary
          const Text(
            'Remaining Data',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textGrey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                (esim.dataTotalGb - esim.dataUsedGb).clamp(0.0, esim.dataTotalGb).toStringAsFixed(1),
                style: const TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textBlack,
                  letterSpacing: -2.0,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'GB',
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Massive Apple-Style Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: esim.dataUsagePercent,
              minHeight: 16,
              backgroundColor: Colors.black.withValues(alpha: 0.05),
              valueColor: AlwaysStoppedAnimation<Color>(
                esim.isExpired ? const Color(0xFFEF4444) : gradientColors.first,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Expiry and Allocation Tags
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tagChip(
                icon: Icons.data_usage_rounded,
                text: 'Total: ${esim.dataTotalGb.toStringAsFixed(1)} GB',
              ),
              _tagChip(
                icon: Icons.calendar_today_rounded,
                text: esim.isExpired ? 'Expired' : 'Valid until Dec 31',
                isWarning: esim.isExpired,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _holographicChip(List<Color> gradientColors, IconData icon, var esim) {
    return Container(
      width: 260,
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.4),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Holographic reflection overlay
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0), // Just for structure
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.3),
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: 0.1),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Card Details
          Positioned(
            left: 24,
            top: 24,
            child: Row(
              children: [
                if (esim.flag != null) ...[
                  Text(esim.flag!, style: const TextStyle(fontSize: 28)),
                ] else if (esim.isRegional) ...[
                  const Icon(Icons.language, size: 28, color: Colors.white),
                ] else ...[
                  Icon(icon, size: 36, color: Colors.white),
                ]
              ],
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  esim.title.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Fustat',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  esim.subtitle.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Fustat',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          // Wi-Fi signal graphic
          const Positioned(
            right: 24,
            top: 24,
            child: Icon(Icons.signal_cellular_alt_rounded, size: 28, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _tagChip({required IconData icon, required String text, bool isWarning = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isWarning ? const Color(0xFFEF4444).withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, 
            size: 14, 
            color: isWarning ? const Color(0xFFEF4444) : AppColors.textGrey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isWarning ? const Color(0xFFEF4444) : AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
