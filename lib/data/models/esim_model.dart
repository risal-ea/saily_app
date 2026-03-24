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
  final double dataTotalGb;
  final double dataUsedGb;
  final String? flag; // e.g. '🇮🇳' — used when coverage is country
  final List<int> gradientColors; // stored as ARGB ints to stay Flutter-free
  final int iconCodePoint; // codepoint for the card chip icon

  const ESimModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.coverage,
    this.dataTotalGb = 0.0,
    this.dataUsedGb = 0.0,
    this.flag,
    required this.gradientColors,
    required this.iconCodePoint,
  });

  bool get isActive => status == ESimStatus.active;
  bool get isRegional => coverage == ESimCoverage.regional;
  bool get isExpired => status == ESimStatus.expired || (dataTotalGb > 0 && dataUsedGb >= dataTotalGb);

  double get dataUsagePercent {
    if (dataTotalGb <= 0) return 0.0;
    // Calculate remaining percentage so the progress bar shrinks over time
    return ((dataTotalGb - dataUsedGb) / dataTotalGb).clamp(0.0, 1.0);
  }

  factory ESimModel.fromJson(Map<String, dynamic> json) {
    return ESimModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      status: json['status'] == 'active' ? ESimStatus.active : ESimStatus.expired,
      coverage: json['coverage'] == 'country' ? ESimCoverage.country : ESimCoverage.regional,
      dataTotalGb: (json['dataTotalGb'] as num?)?.toDouble() ?? 0.0,
      dataUsedGb: (json['dataUsedGb'] as num?)?.toDouble() ?? 0.0,
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
      'dataTotalGb': dataTotalGb,
      'dataUsedGb': dataUsedGb,
      'flag': flag,
      'gradientColors': gradientColors,
      'iconCodePoint': iconCodePoint,
    };
  }

  ESimModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    ESimStatus? status,
    ESimCoverage? coverage,
    double? dataTotalGb,
    double? dataUsedGb,
    String? flag,
    List<int>? gradientColors,
    int? iconCodePoint,
  }) {
    return ESimModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      status: status ?? this.status,
      coverage: coverage ?? this.coverage,
      dataTotalGb: dataTotalGb ?? this.dataTotalGb,
      dataUsedGb: dataUsedGb ?? this.dataUsedGb,
      flag: flag ?? this.flag,
      gradientColors: gradientColors ?? this.gradientColors,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
    );
  }
}
