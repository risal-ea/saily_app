

enum PlanCategory { country, regional }

class DataPlanModel {
  final String id;
  final String name;
  final String flag;
  final double startingPrice;
  final String description;
  final PlanCategory category;
  final bool isTopPick;

  const DataPlanModel({
    required this.id,
    required this.name,
    required this.flag,
    required this.startingPrice,
    required this.description,
    required this.category,
    this.isTopPick = false,
  });

  String get formattedPrice => 'From US\$${startingPrice.toStringAsFixed(2)}';
}
