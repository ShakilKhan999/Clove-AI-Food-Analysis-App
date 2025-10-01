import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/controllers/recpei_controller.dart';
import 'package:food_recepi/helpers/color_helper.dart';
import 'package:food_recepi/views/home_view.dart';
import 'package:food_recepi/widgets/recpeiCard.dart';
import 'package:get/get.dart';
// Add import for ColorHelper if not already imported
// import 'package:food_recepi/helpers/color_helper.dart';

class RecpeiView extends StatelessWidget {
  const RecpeiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecipeController controller = Get.put(RecipeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorHelper.primaryColor,
        elevation: 0,
        title: const Text(
          'Recipes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add,
                color: ColorHelper.primaryColor), // Changed from white
            onPressed: () {
              Get.to(HomeView());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.categories.map((category) {
                        return Column(
                          children: [
                            _buildCategorySection(category, controller),
                            const SizedBox(height: 24),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, RecipeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View More',
                style: TextStyle(color: ColorHelper.primaryColor),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 240,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.getRecipesByCategory(category).length,
              itemBuilder: (context, index) {
                final recipe = controller.getRecipesByCategory(category)[index];
                return RecipeCard(recipe: recipe);
              },
            ),
          ),
        ),
      ],
    );
  }
}
