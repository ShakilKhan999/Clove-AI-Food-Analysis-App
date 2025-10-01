import 'package:food_recepi/models/recpei_model.dart';
import 'package:get/get.dart';

class RecipeController extends GetxController {
  RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  RxBool isLoading = true.obs;
  RxList<String> categories =
      <String>['Popular recipes', 'Pantry Staples', 'Pre-Workout'].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  void fetchRecipes() {
    try {
      isLoading.value = true;
      recipes.value = [
        RecipeModel(
          title: 'Overnight Orange Crepes',
          imageUrl: 'assets/images/clove1.jpg',
          calories: 201,
          tags: ['Popular recipes', 'Breakfast', 'Vegetarian'],
          nutrition: {
            'Carbs': 31.5,
            'Fat': 6.1,
            'Protein': 6.7,
          },
          ingredients: [
            '1 3/4 cups unsweetened almond milk',
            '1 cup whole-wheat flour',
            '3 large eggs',
            '1 tablespoon safflower oil',
            '1 teaspoon vanilla extract',
          ],
          directions: [
            'Put the almond milk, flour, eggs, safflower oil, vanilla, turmeric and salt in a blender and process until smooth.',
            'Remove the peel and white pith from the oranges.',
            'Heat oven to 200°F (93°C).',
            'Repeat with remaining batter.',
          ],
          servings: 6,
        ),
        RecipeModel(
          title: 'Overnight Orange Crepes',
          imageUrl: 'assets/images/clove2.jpg',
          calories: 201,
          tags: ['Popular recipes', 'Breakfast', 'Vegetarian'],
          nutrition: {
            'Carbs': 31.5,
            'Fat': 6.1,
            'Protein': 6.7,
          },
          ingredients: [
            '1 3/4 cups unsweetened almond milk',
            '1 cup whole-wheat flour',
            '3 large eggs',
            '1 tablespoon safflower oil',
            '1 teaspoon vanilla extract',
          ],
          directions: [
            'Put the almond milk, flour, eggs, safflower oil, vanilla, turmeric and salt in a blender and process until smooth.',
            'Remove the peel and white pith from the oranges.',
            'Heat oven to 200°F (93°C).',
            'Repeat with remaining batter.',
          ],
          servings: 6,
        ),
        RecipeModel(
          title: 'Overnight Orange Crepes',
          imageUrl: 'assets/images/clove3.jpg',
          calories: 201,
          tags: ['Popular recipes', 'Breakfast', 'Vegetarian'],
          nutrition: {
            'Carbs': 31.5,
            'Fat': 6.1,
            'Protein': 6.7,
          },
          ingredients: [
            '1 3/4 cups unsweetened almond milk',
            '1 cup whole-wheat flour',
            '3 large eggs',
            '1 tablespoon safflower oil',
            '1 teaspoon vanilla extract',
          ],
          directions: [
            'Put the almond milk, flour, eggs, safflower oil, vanilla, turmeric and salt in a blender and process until smooth.',
            'Remove the peel and white pith from the oranges.',
            'Heat oven to 200°F (93°C).',
            'Repeat with remaining batter.',
          ],
          servings: 6,
        ),
        RecipeModel(
          title: 'Quinoa Power Bowl',
          imageUrl: 'assets/images/quinoa_bowl.jpg',
          calories: 420,
          tags: ['Pre-Workout', 'Lunch', 'High-Protein'],
          nutrition: {
            'Carbs': 45.0,
            'Fat': 15.2,
            'Protein': 22.5,
          },
          ingredients: [
            '1 cup quinoa',
            '2 cups vegetable broth',
            '1 can chickpeas',
            '2 cups kale',
            'Cherry tomatoes',
          ],
          directions: [
            'Rinse quinoa and cook in vegetable broth',
            'Drain and rinse chickpeas',
            'Massage kale with olive oil',
            'Combine all ingredients in a bowl',
            'Season to taste',
          ],
          servings: 4,
        ),
        RecipeModel(
          title: 'Quinoa Power Bowl',
          imageUrl: 'assets/images/quinoa_bowl.jpg',
          calories: 420,
          tags: ['Pre-Workout', 'Lunch', 'High-Protein'],
          nutrition: {
            'Carbs': 45.0,
            'Fat': 15.2,
            'Protein': 22.5,
          },
          ingredients: [
            '1 cup quinoa',
            '2 cups vegetable broth',
            '1 can chickpeas',
            '2 cups kale',
            'Cherry tomatoes',
          ],
          directions: [
            'Rinse quinoa and cook in vegetable broth',
            'Drain and rinse chickpeas',
            'Massage kale with olive oil',
            'Combine all ingredients in a bowl',
            'Season to taste',
          ],
          servings: 4,
        ),
        RecipeModel(
          title: 'Quinoa Power Bowl',
          imageUrl: 'assets/images/quinoa_bowl.jpg',
          calories: 420,
          tags: ['Pre-Workout', 'Lunch', 'High-Protein'],
          nutrition: {
            'Carbs': 45.0,
            'Fat': 15.2,
            'Protein': 22.5,
          },
          ingredients: [
            '1 cup quinoa',
            '2 cups vegetable broth',
            '1 can chickpeas',
            '2 cups kale',
            'Cherry tomatoes',
          ],
          directions: [
            'Rinse quinoa and cook in vegetable broth',
            'Drain and rinse chickpeas',
            'Massage kale with olive oil',
            'Combine all ingredients in a bowl',
            'Season to taste',
          ],
          servings: 4,
        ),
        RecipeModel(
          title: 'Homemade Granola',
          imageUrl: 'assets/images/granola.jpg',
          calories: 289,
          tags: ['Pantry Staples', 'Breakfast', 'Vegetarian'],
          nutrition: {
            'Carbs': 32.4,
            'Fat': 14.8,
            'Protein': 6.2,
          },
          ingredients: [
            '3 cups rolled oats',
            '1 cup mixed nuts',
            '1/2 cup honey',
            '1/3 cup coconut oil',
            '1 teaspoon cinnamon',
          ],
          directions: [
            'Preheat oven to 325°F (165°C)',
            'Mix dry ingredients in a large bowl',
            'Warm honey and coconut oil, pour over dry ingredients',
            'Spread on baking sheet and bake for 20-25 minutes',
            'Let cool completely before storing',
          ],
          servings: 8,
        ),
        RecipeModel(
          title: 'Homemade Granola',
          imageUrl: 'assets/images/granola.jpg',
          calories: 289,
          tags: ['Pantry Staples', 'Breakfast', 'Vegetarian'],
          nutrition: {
            'Carbs': 32.4,
            'Fat': 14.8,
            'Protein': 6.2,
          },
          ingredients: [
            '3 cups rolled oats',
            '1 cup mixed nuts',
            '1/2 cup honey',
            '1/3 cup coconut oil',
            '1 teaspoon cinnamon',
          ],
          directions: [
            'Preheat oven to 325°F (165°C)',
            'Mix dry ingredients in a large bowl',
            'Warm honey and coconut oil, pour over dry ingredients',
            'Spread on baking sheet and bake for 20-25 minutes',
            'Let cool completely before storing',
          ],
          servings: 8,
        ),
        RecipeModel(
          title: 'Homemade Granola',
          imageUrl: 'assets/images/granola.jpg',
          calories: 289,
          tags: ['Pantry Staples', 'Breakfast', 'Vegetarian'],
          nutrition: {
            'Carbs': 32.4,
            'Fat': 14.8,
            'Protein': 6.2,
          },
          ingredients: [
            '3 cups rolled oats',
            '1 cup mixed nuts',
            '1/2 cup honey',
            '1/3 cup coconut oil',
            '1 teaspoon cinnamon',
          ],
          directions: [
            'Preheat oven to 325°F (165°C)',
            'Mix dry ingredients in a large bowl',
            'Warm honey and coconut oil, pour over dry ingredients',
            'Spread on baking sheet and bake for 20-25 minutes',
            'Let cool completely before storing',
          ],
          servings: 8,
        ),
        RecipeModel(
          title: 'Homemade Granola',
          imageUrl: 'assets/images/granola.jpg',
          calories: 289,
          tags: ['Pantry Staples', 'Breakfast', 'Vegetarian'],
          nutrition: {
            'Carbs': 32.4,
            'Fat': 14.8,
            'Protein': 6.2,
          },
          ingredients: [
            '3 cups rolled oats',
            '1 cup mixed nuts',
            '1/2 cup honey',
            '1/3 cup coconut oil',
            '1 teaspoon cinnamon',
          ],
          directions: [
            'Preheat oven to 325°F (165°C)',
            'Mix dry ingredients in a large bowl',
            'Warm honey and coconut oil, pour over dry ingredients',
            'Spread on baking sheet and bake for 20-25 minutes',
            'Let cool completely before storing',
          ],
          servings: 8,
        ),
      ];
    } finally {
      isLoading.value = false;
    }
  }

  List<RecipeModel> getRecipesByCategory(String category) {
    return recipes.where((recipe) => recipe.tags.contains(category)).toList();
  }
}
