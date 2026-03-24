import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/data/models/for_you_card_model.dart';

/// A single smart recommendation card for the "For You" section.
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key, required this.card});

  final ForYouCardModel card;

  // Icon color per card type
  static const Map<ForYouCardType, Color> _iconColors = {
    ForYouCardType.dataUsageWarning: Color(0xFFF59E0B),
    ForYouCardType.securitySuggestion: Color(0xFF3B82F6),
    ForYouCardType.expiryReminder: Color(0xFFF97316),
    ForYouCardType.quickBuy: Color(0xFF10B981),
    ForYouCardType.locationActivation: Color(0xFF7C3AED),
  };

  @override
  Widget build(BuildContext context) {
    final icon = card.iconCodePoint != null
        ? IconData(card.iconCodePoint!, fontFamily: 'MaterialIcons')
        : null;
    final iconColor = _iconColors[card.type];
    final bgColor =
        card.isHighlighted ? const Color(0xFFF4F0FF) : Colors.white;
    final textColor = card.isHighlighted
        ? AppColors.homeGradientStart
        : AppColors.textBlack;
    final btnColor = card.isHighlighted
        ? AppColors.homeGradientStart
        : const Color(0xFF111827);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: card.isHighlighted
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
        border: card.isHighlighted
            ? null
            : Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _iconArea(icon, iconColor),
          const SizedBox(width: 16),
          _textArea(textColor),
          const SizedBox(width: 12),
          _ctaButton(btnColor),
        ],
      ),
    );
  }

  Widget _iconArea(IconData? icon, Color? iconColor) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (card.progress != null)
            SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                value: card.progress,
                strokeWidth: 3,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  card.progress! > 0.7
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF10B981),
                ),
              ),
            ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: card.isHighlighted
                  ? Colors.white.withValues(alpha: 0.6)
                  : (iconColor?.withValues(alpha: 0.1) ??
                      Colors.grey.withValues(alpha: 0.1)),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: card.flag != null
                  ? Text(card.flag!, style: const TextStyle(fontSize: 18))
                  : Icon(icon,
                      size: 18, color: iconColor ?? AppColors.textBlack),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textArea(Color textColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            card.title,
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            card.subtitle,
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: card.isHighlighted
                  ? textColor.withValues(alpha: 0.7)
                  : AppColors.textGrey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _ctaButton(Color btnColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        card.ctaText,
        style: const TextStyle(
          fontFamily: 'Fustat',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
