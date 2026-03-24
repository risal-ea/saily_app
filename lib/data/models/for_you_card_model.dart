// file: lib/data/models/for_you_card_model.dart
// Plain Dart class — no Flutter imports.

enum ForYouCardType {
  locationActivation,
  dataUsageWarning,
  expiryReminder,
  quickBuy,
  securitySuggestion,
}

class ForYouCardModel {
  final String id;
  final ForYouCardType type;
  final String title;
  final String subtitle;
  final String ctaText;
  final String? flag;       // e.g. '🇦🇪' for country cards
  final bool isHighlighted; // elevated/tinted card style
  final double? progress;   // 0.0–1.0 for data usage bar, null if unused
  final int? iconCodePoint; // Material icon codepoint, null if flag is used

  const ForYouCardModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    this.flag,
    this.isHighlighted = false,
    this.progress,
    this.iconCodePoint,
  });

  factory ForYouCardModel.fromJson(Map<String, dynamic> json) {
    return ForYouCardModel(
      id: json['id'] as String,
      type: ForYouCardType.values.byName(json['type'] as String),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      ctaText: json['ctaText'] as String,
      flag: json['flag'] as String?,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble(),
      iconCodePoint: json['iconCodePoint'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'subtitle': subtitle,
      'ctaText': ctaText,
      'flag': flag,
      'isHighlighted': isHighlighted,
      'progress': progress,
      'iconCodePoint': iconCodePoint,
    };
  }
}
