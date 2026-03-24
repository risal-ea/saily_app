// file: lib/data/models/esim_model.dart
// Plain Dart class — no Flutter imports.

enum ESimStatus { active, expired }
enum ESimCoverage { country, regional }

class ESimModel {
  final String id;
  final String title;
  final String subtitle;
  final ESimStatus status;
  final ESimCoverage coverage;
  final String? flag; // e.g. '🇮🇳' — used when coverage is country
  final List<int> gradientColors; // stored as ARGB ints to stay Flutter-free
  final int iconCodePoint; // codepoint for the card chip icon

  const ESimModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.coverage,
    this.flag,
    required this.gradientColors,
    required this.iconCodePoint,
  });

  bool get isActive => status == ESimStatus.active;
  bool get isRegional => coverage == ESimCoverage.regional;

  factory ESimModel.fromJson(Map<String, dynamic> json) {
    return ESimModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      status: json['status'] == 'active' ? ESimStatus.active : ESimStatus.expired,
      coverage: json['coverage'] == 'country' ? ESimCoverage.country : ESimCoverage.regional,
      flag: json['flag'] as String?,
      gradientColors: List<int>.from(json['gradientColors'] as List),
      iconCodePoint: json['iconCodePoint'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'status': status.name,
      'coverage': coverage.name,
      'flag': flag,
      'gradientColors': gradientColors,
      'iconCodePoint': iconCodePoint,
    };
  }
}
