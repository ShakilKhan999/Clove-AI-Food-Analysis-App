

import 'nutrition_model.dart';

class FoodData {
  final String foodName;
  final String description;
  final String portionSize;
  final Nutrition nutrition;
  final String glucoseImpact;
  final List<String> recommendations;

  FoodData({
    required this.foodName,
    required this.description,
    required this.portionSize,
    required this.nutrition,
    required this.glucoseImpact,
    required this.recommendations,
  });

  factory FoodData.fromJson(Map<String, dynamic> json) {
    return FoodData(
      foodName: json['foodName'] ?? '',
      description: json['description'] ?? '',
      portionSize: json['portionSize'] ?? '',
      nutrition: Nutrition.fromJson(json['nutrition'] ?? {}),
      glucoseImpact: json['glucoseImpact'] ?? '',
      recommendations: (json['recommendations'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'description': description,
      'portionSize': portionSize,
      'nutrition': nutrition.toJson(),
      'glucoseImpact': glucoseImpact,
      'recommendations': recommendations,
    };
  }
}
