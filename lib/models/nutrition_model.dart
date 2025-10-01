class Nutrition {
  final String calories;
  final String carbohydrates;
  final String protein;
  final String fat;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories'] ?? '0',
      carbohydrates: json['carbohydrates'] ?? '0',
      protein: json['protein'] ?? '0',
      fat: json['fat'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'carbohydrates': carbohydrates,
      'protein': protein,
      'fat': fat,
    };
  }
}
