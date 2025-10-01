import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/helpers/color_helper.dart';
import 'package:food_recepi/views/profile_screen.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:shimmer/shimmer.dart';

import '../auth/controller/auth_controller.dart';
import 'logs/log_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthController authController = Get.put(AuthController());
  LogController logController = Get.put(LogController());

  @override
  void initState() {
    authController.getData();
    super.initState();
  }

  int calculateTodayCalories() {
    if (authController.allMealList.isEmpty) return 0;
    final today = DateTime.now();
    try {
      final List<Map<String, dynamic>> processedMeals =
          authController.allMealList.value.cast<Map<String, dynamic>>();

      return processedMeals.where((meal) {
        final mealDate = (meal['dateTime'] as Timestamp).toDate();
        return mealDate.year == today.year &&
            mealDate.month == today.month &&
            mealDate.day == today.day;
      }).fold(0, (sum, meal) => sum + (meal['kCal'] as int));
    } catch (e) {
      print('Error calculating calories: $e');
      return 0;
    }
  }

  Map<String, String> selectedImages = {
    'Breakfast': 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666',
    'Lunch': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    'Dinner': 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2',
    'Snacks': 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087',
  };

  double calculateProgress() {
    final dailyGoal = 2000;
    return (calculateTodayCalories() / dailyGoal).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                Obx(() => Column(
                      children: [
                        _buildQuickStatsSection(),
                        _buildMainContent(),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerCards() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Food Categories'),
          SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.2,
            children: [
              _buildImageCard(
                title: 'Breakfast',
                icon: Icons.breakfast_dining,
                initialImage: selectedImages['Breakfast']!,
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      selectedImages['Breakfast'] = image.path;
                    });
                  }
                },
              ),
              _buildImageCard(
                title: 'Lunch',
                icon: Icons.lunch_dining,
                initialImage: selectedImages['Lunch']!,
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      selectedImages['Lunch'] = image.path;
                    });
                  }
                },
              ),
              _buildImageCard(
                title: 'Dinner',
                icon: Icons.dinner_dining,
                initialImage: selectedImages['Dinner']!,
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      selectedImages['Dinner'] = image.path;
                    });
                  }
                },
              ),
              _buildImageCard(
                title: 'Snacks',
                icon: Icons.cookie,
                initialImage: selectedImages['Snacks']!,
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      selectedImages['Snacks'] = image.path;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard({
    required String title,
    required IconData icon,
    required String initialImage,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              selectedImages[title]!.startsWith('http')
                  ? Image.network(
                      selectedImages[title]!,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(selectedImages[title]!),
                      fit: BoxFit.cover,
                    ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                    'Hello, ${authController.userInfo.isEmpty ? "" : authController.userInfo[0]["fullName"]}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ColorHelper.primaryColor,
                    ),
                  )),
              Text(
                'Let\'s track your meals',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorHelper.primaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.to(ProfileScreen());
            },
            child: Container(
              height: 50.h,
              width: 50.h,
              decoration: BoxDecoration(
                // border: Border.all(
                //     color: ColorHelper.primaryColor.withOpacity(0.8), width: 2),
                borderRadius: BorderRadius.circular(90),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Obx(() => Image.network(
                      fit: BoxFit.cover,
                      height: 50.h,
                      width: 50.h,
                      authController.userInfo.isNotEmpty &&
                              authController.userInfo[0]["photoURL"] != null
                          ? authController.userInfo[0]["photoURL"]
                          : "https://coenterprises.com.au/wp-content/uploads/2018/02/male-placeholder-image.jpeg"))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    final todayCalories = calculateTodayCalories();
    final dailyGoal = 2000;
    final remaining = math.max(0, dailyGoal - todayCalories);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Calories',
              '${authController.isLoading.value ? "---" : todayCalories}',
              'kcal',
              ColorHelper.primaryColor.withOpacity(0.8),
              Icons.local_fire_department_rounded,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: _buildStatCard(
              'Remaining',
              '${authController.isLoading.value ? "---" : remaining}',
              'kcal',
              Colors.orange.shade500,
              Icons.timer_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String unit, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Today\'s Meals'),
          SizedBox(height: 15),
          _buildMealsList(),
          SizedBox(height: 25),
          _buildSectionTitle('Weekly Progress'),
          SizedBox(height: 15),
          WeeklyCaloryChart(mealList: authController.allMealList.value),
          SizedBox(height: 25),
          _buildImagePickerCards(),
          SizedBox(height: 25),
          _buildFoodImagesSection(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: ColorHelper.primaryColor.withOpacity(0.8),
      ),
    );
  }

  Widget _buildMealsList() {
    if (authController.isLoading.value) {
      return _buildMealsListShimmer();
    }

    final todayMeals = getTodayMeals();
    if (todayMeals.isEmpty) {
      return Center(
        child: Text(
          'No meals recorded today',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
      );
    }

    return Column(
      children: todayMeals.map((meal) {
        final mealTime = (meal['dateTime'] as Timestamp).toDate();
        return Column(
          children: [
            _buildMealCard(
              meal['category'],
              meal['foodName'],
              meal['kCal'].toString(),
              DateFormat('h:mm a').format(mealTime),
              _getCategoryColor(meal['category']),
              _getCategoryIcon(meal['category']),
            ),
            SizedBox(height: 15),
          ],
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> getTodayMeals() {
    if (authController.allMealList.isEmpty) return [];

    final today = DateTime.now();
    final List<Map<String, dynamic>> processedMeals =
        authController.allMealList.value.cast<Map<String, dynamic>>();

    return processedMeals.where((meal) {
      final mealDate = (meal['dateTime'] as Timestamp).toDate();
      return mealDate.year == today.year &&
          mealDate.month == today.month &&
          mealDate.day == today.day;
    }).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return Colors.orange.shade700;
      case 'lunch':
        return Colors.green.shade600;
      case 'dinner':
        return Colors.blue.shade600;
      case 'snack':
        return Colors.purple.shade600;
      default:
        return Colors.grey.shade700;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snack':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  Widget _buildMealCard(String type, String name, String calories, String time,
      Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$calories kcal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSpikeCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.show_chart,
            color: Colors.orange.shade700,
            size: 30,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Spike',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                logController.allLogs.isEmpty
                    ? "LOW"
                    : logController.allLogs.first.foodData?.glucoseImpact ??
                        'N/A',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Quick Actions'),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionTile(
                icon: Icons.local_dining_outlined,
                title: 'Meal Plan',
                subtitle: 'View your plan',
                color: Colors.blue,
                onTap: () {
                  // Handle meal plan tap
                },
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: _buildQuickActionTile(
                icon: Icons.favorite_outline,
                title: 'Favorites',
                subtitle: '12 meals saved',
                color: Colors.red,
                onTap: () {
                  // Handle favorites tap
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionTile(
                icon: Icons.history,
                title: 'History',
                subtitle: 'Past 7 days',
                color: Colors.purple,
                onTap: () {
                  // Handle history tap
                },
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: _buildQuickActionTile(
                icon: Icons.auto_graph,
                title: 'Analytics',
                subtitle: 'View insights',
                color: Colors.orange,
                onTap: () {
                  // Handle analytics tap
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        _buildSectionTitle('Nutrition Tracking'),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.green.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildNutrientProgressBar(
                label: 'Protein',
                current: 45,
                target: 60,
                unit: 'g',
                color: Colors.blue.shade700,
              ),
              SizedBox(height: 15),
              _buildNutrientProgressBar(
                label: 'Carbs',
                current: 180,
                target: 250,
                unit: 'g',
                color: Colors.orange.shade700,
              ),
              SizedBox(height: 15),
              _buildNutrientProgressBar(
                label: 'Fats',
                current: 35,
                target: 65,
                unit: 'g',
                color: Colors.purple.shade700,
              ),
              SizedBox(height: 15),
              _buildNutrientProgressBar(
                label: 'Fiber',
                current: 15,
                target: 25,
                unit: 'g',
                color: Colors.green.shade700,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientProgressBar({
    required String label,
    required int current,
    required int target,
    required String unit,
    required Color color,
  }) {
    final progress = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              '$current/$target $unit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: progress,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.green.shade700, size: 24),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsListShimmer() {
    return Column(
      children: List.generate(
          2,
          (index) => Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child:
                        ShimmerLoadingState(width: double.infinity, height: 80),
                  ),
                  SizedBox(height: 15),
                ],
              )).toList(),
    );
  }
}

class WeeklyCaloryChart extends StatefulWidget {
  final dynamic mealList;

  WeeklyCaloryChart({required this.mealList});

  @override
  State<WeeklyCaloryChart> createState() => _WeeklyCaloryChartState();
}

class _WeeklyCaloryChartState extends State<WeeklyCaloryChart> {
  bool hasNextData = false;
  bool hasPrevData = false;
  AuthController authController = Get.find();

  List<FlSpot> getChartData() {
    final spots = <FlSpot>[];
    final now = DateTime.now();
    final endDate =
        now.subtract(Duration(days: 7 * authController.weekOffset.value));
    final startDate = endDate.subtract(const Duration(days: 6));

    try {
      final List<Map<String, dynamic>> processedMeals =
          widget.mealList.cast<Map<String, dynamic>>();

      // Check next week data
      final nextWeekData = processedMeals.where((meal) {
        final mealDate = (meal['dateTime'] as Timestamp).toDate();
        final nextWeekStart = now.subtract(
            Duration(days: 7 * (authController.weekOffset.value - 1)));
        return mealDate.isAfter(nextWeekStart);
      });
      hasNextData =
          nextWeekData.isNotEmpty && authController.weekOffset.value > 0;

      // Check previous week data
      final prevWeekData = processedMeals.where((meal) {
        final mealDate = (meal['dateTime'] as Timestamp).toDate();
        final prevWeekEnd = now.subtract(
            Duration(days: 7 * (authController.weekOffset.value + 1)));
        return mealDate.isBefore(prevWeekEnd);
      });
      hasPrevData = prevWeekData.isNotEmpty;

      for (int i = 0; i < 7; i++) {
        final date = startDate.add(Duration(days: i));
        final dayCalories = processedMeals.where((meal) {
          final mealDate = (meal['dateTime'] as Timestamp).toDate();
          return mealDate.year == date.year &&
              mealDate.month == date.month &&
              mealDate.day == date.day;
        }).fold(0, (sum, meal) => sum + (meal['kCal'] as int));

        spots.add(FlSpot(i.toDouble(), dayCalories.toDouble()));
      }
    } catch (e) {
      print('Error processing meal data: $e');
    }

    return spots.isEmpty
        ? List.generate(7, (index) => FlSpot(index.toDouble(), 0))
        : spots;
  }

  String getDayLabel(int dayOffset) {
    final now = DateTime.now();
    final endDate =
        now.subtract(Duration(days: 7 * authController.weekOffset.value));
    final startDate = endDate.subtract(const Duration(days: 6));
    final date = startDate.add(Duration(days: dayOffset));
    return DateFormat('E').format(date)[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 500,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade200,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 500,
                          reservedSize: 35,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                getDayLabel(value.toInt()),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.green.shade600,
                        tooltipRoundedRadius: 12,
                        tooltipPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            final now = DateTime.now();
                            final endDate = now.subtract(Duration(
                                days: 7 * authController.weekOffset.value));
                            final startDate =
                                endDate.subtract(const Duration(days: 6));
                            final date = startDate
                                .add(Duration(days: touchedSpot.x.toInt()));
                            return LineTooltipItem(
                              '${DateFormat('MMM d').format(date)}',
                              TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: '\n${touchedSpot.y.toInt()} kcal',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                      ),
                      getTouchedSpotIndicator:
                          (LineChartBarData barData, List<int> indicators) {
                        return indicators.map(
                          (int index) {
                            return TouchedSpotIndicatorData(
                              FlLine(
                                color: Colors.green.shade300,
                                strokeWidth: 1.5,
                                dashArray: [4, 4],
                              ),
                              FlDotData(
                                getDotPainter:
                                    (spot, percent, barData, index) =>
                                        FlDotCirclePainter(
                                  radius: 5,
                                  color: Colors.white,
                                  strokeWidth: 3,
                                  strokeColor: Colors.green.shade400,
                                ),
                              ),
                            );
                          },
                        ).toList();
                      },
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: getChartData(),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: Colors.green.shade400,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 3,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.green.shade400,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.green.shade400.withOpacity(0.2),
                              Colors.green.shade400.withOpacity(0.0),
                            ],
                            stops: [0.0, 0.8],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (hasPrevData)
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.chevron_left,
                      color: Colors.green.shade600, size: 22),
                  onPressed: () {
                    authController.weekOffset++;
                  },
                ),
              ),
            ),
          if (hasNextData)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.chevron_right,
                      color: Colors.green.shade600, size: 22),
                  onPressed: () {
                    authController.weekOffset.value =
                        math.max(0, authController.weekOffset.value - 1);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ShimmerLoadingState extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoadingState({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}
