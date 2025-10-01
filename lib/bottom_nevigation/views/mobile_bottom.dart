import 'package:flutter/material.dart';
import 'package:food_recepi/helpers/color_helper.dart';
import 'package:food_recepi/views/chatbot_view.dart';
import 'package:food_recepi/views/home_view.dart';
import 'package:get/get.dart';

import '../../auth/controller/auth_controller.dart';
import '../../views/home_screen.dart';
import '../../views/live_alalysis/live_analysis.dart';
import '../../views/logs/logs_screen.dart';
import '../../views/manually_input_screen.dart';
import '../../views/meal_screen.dart';
import '../../views/profile_screen.dart';
import '../../views/recpei_view.dart';
import '../../views/take_photo_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key});
  final RxInt selectedIndex = 0.obs;
  final RxBool isExpanded = false.obs;

  final List<Widget> screens = [
    HomeScreen(),
    MealTrackerScreen(),
    LogsScreen(),
    RecpeiView(),
  ];

  final List<Widget> homeSubScreens = [TakePhotoScreen(), ManualEntryScreen()];

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() => selectedIndex.value == 0 &&
                  authController.homeRouteIndex.value != 100
              ? homeSubScreens[authController.homeRouteIndex.value]
              : screens[selectedIndex.value]),
          // Animated Action Buttons
          Obx(() => AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: isExpanded.value ? 80 : -80,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      icon: Icons.camera_alt,
                      label: 'Take Photo',
                      onTap: () {
                        authController.homeRouteIndex.value = 100;
                        Get.to(() => TakePhotoScreen());
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildActionButton(
                      icon: Icons.analytics,
                      label: 'Live Analysis',
                      onTap: () => Get.to(() => LiveFoodAnalysisScreen()),
                    ),
                  ],
                ),
              )),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_filled, 'Home'),
                _buildNavItem(1, Icons.set_meal, 'Meal'),
                _buildAddButton(),
                _buildNavItem(2, Icons.insights, 'Logs'),
                _buildNavItem(3, Icons.rice_bowl, 'Recipe'),
              ],
            ),
          ),
          const SizedBox(height: 8), // Safe area padding
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: ColorHelper.primaryColor.withOpacity(0.8)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: ColorHelper.primaryColor.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Obx(() => GestureDetector(
          onTap: () => isExpanded.value = !isExpanded.value,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: ColorHelper.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedRotation(
              duration: const Duration(milliseconds: 300),
              turns: isExpanded.value ? 0.125 : 0, // 45 degrees when expanded
              child: Obx(() => Icon(
                    isExpanded.value ? Icons.add : Icons.camera,
                    color: Colors.white,
                    size: 24,
                  )),
            ),
          ),
        ));
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return Obx(() => InkWell(
          onTap: () {
            selectedIndex.value = index;
            isExpanded.value = false;
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selectedIndex.value == index
                    ? ColorHelper.primaryColor.withOpacity(0.8)
                    : Colors.grey,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: selectedIndex.value == index
                      ? ColorHelper.primaryColor.withOpacity(0.8)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ));
  }
}
