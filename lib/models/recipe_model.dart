// recipe_model.dart

class Recipe {
  final String name;
  final String description;
  final String healthBenefits;
  final String category;
  final List<String> ingredients;
  final List<String> instructions;
  final Map<String, String> nutrition;

  Recipe({
    required this.name,
    required this.description,
    required this.healthBenefits,
    required this.category,
    required this.ingredients,
    required this.instructions,
    required this.nutrition,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      healthBenefits: json['healthBenefits'] ?? '',
      category: json['category'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      nutrition: Map<String, String>.from(json['nutrition'] ?? {}),
    );
  }
}

class RecipeResponse {
  final bool success;
  final String message;
  final List<Recipe> recipes;
  final String? error;

  RecipeResponse({
    required this.success,
    required this.message,
    required this.recipes,
    this.error,
  });

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    return RecipeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      recipes: (json['recipes'] as List? ?? [])
          .map((recipe) => Recipe.fromJson(recipe))
          .toList(),
      error: json['error'],
    );
  }
}