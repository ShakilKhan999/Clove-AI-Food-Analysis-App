class RecipeModel {
  final String title;
  final String imageUrl;
  final int calories;
  final List<String> tags;
  final Map<String, double> nutrition;
  final List<String> ingredients;
  final List<String> directions;
  final int servings;

  RecipeModel({
    required this.title,
    required this.imageUrl,
    required this.calories,
    required this.tags,
    required this.nutrition,
    required this.ingredients,
    required this.directions,
    required this.servings,
  });
}