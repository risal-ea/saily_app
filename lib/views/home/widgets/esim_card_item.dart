import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/data/models/esim_model.dart';
import 'package:saily_app/views/esim_details/esim_details_screen.dart';

/// Individual eSIM card in the horizontal carousel.
class ESimCardItem extends StatelessWidget {
  const ESimCardItem({super.key, required this.esim});

  final ESimModel esim;

  @override
  Widget build(BuildContext context) {
    final gradientColors = esim.gradientColors.map((c) => Color(c)).toList();
    final icon = IconData(esim.iconCodePoint, fontFamily: 'MaterialIcons');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EsimDetailsScreen(esim: esim),
          ),
        );
      },
      child: Container(
      width: 148,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _chipGraphic(gradientColors, icon),
          const Spacer(),
          _titleRow(),
          const SizedBox(height: 2),
          _statusRow(),
        ],
      ),
    ));
  }

  Widget _chipGraphic(List<Color> gradientColors, IconData icon) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'SAILY',
                  style: TextStyle(
                    fontFamily: 'Fustat',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Icon(icon, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _titleRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            esim.title,
            style: const TextStyle(
              fontFamily: 'Fustat',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlack,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        if (esim.flag != null)
          Text(esim.flag!, style: const TextStyle(fontSize: 14))
        else if (esim.isRegional)
          const Icon(Icons.language, size: 16, color: AppColors.textGrey),
      ],
    );
  }

  Widget _statusRow() {
    final color =
        esim.isActive ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          esim.isActive ? 'Active' : 'Expired',
          style: TextStyle(
            fontFamily: 'Fustat',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
