import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/views/take_photo_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../auth/controller/auth_controller.dart';
import '../auth/controller/auth_serviece.dart';
import '../helpers/color_helper.dart';

class MealTrackerScreen extends StatefulWidget {
  const MealTrackerScreen({super.key});

  @override
  State<MealTrackerScreen> createState() => _MealTrackerScreenState();
}

class _MealTrackerScreenState extends State<MealTrackerScreen> {
  final double _calorieGoal = 2000;
  final ImagePicker _picker = ImagePicker();
  final AuthController authController = Get.find();

  @override
  void initState() {
    authController.isMealTracking.value = false;
    super.initState();
  }

  final List<Map<String, dynamic>> _mealTypes = [
    {
      'name': 'Breakfast',
      'time': '8:00 AM',
      'icon': Icons.breakfast_dining,
      'color': const Color(0xFF6C63FF),
    },
    {
      'name': 'Lunch',
      'time': '1:00 PM',
      'icon': Icons.lunch_dining,
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Dinner',
      'time': '8:00 PM',
      'icon': Icons.dinner_dining,
      'color': const Color(0xFFFF6B6B),
    },
  ];

  int getMealCalories(String category) {
    return authController.mealList
        .where((meal) => meal['category'] == category)
        .fold(0, (sum, meal) => sum + (meal['kCal'] as int));
  }

  double get _consumedCalories {
    return authController.mealList.fold(0, (sum, meal) => sum + meal['kCal']);
  }

  double get _remainingCalories => _calorieGoal - _consumedCalories;

  void _addFood(int mealIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String foodName = '';
        double calories = 0;

        return Obx(() => Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _mealTypes[mealIndex]['icon'],
                          color: _mealTypes[mealIndex]['color'],
                          size: 28.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Add Food to ${_mealTypes[mealIndex]['name']}',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: _mealTypes[mealIndex]['color'],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    _buildInputField(
                      'Food Name',
                      Icons.restaurant_menu,
                      _mealTypes[mealIndex]['color'],
                      onChanged: (value) => foodName = value,
                    ),
                    SizedBox(height: 16.h),
                    _buildInputField(
                      'Calories',
                      Icons.local_fire_department,
                      _mealTypes[mealIndex]['color'],
                      keyboardType: TextInputType.number,
                      suffixText: 'kcal',
                      onChanged: (value) =>
                          calories = double.tryParse(value) ?? 0,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            'Cancel',
                            onPressed: () => Navigator.pop(context),
                            isOutlined: true,
                            color: _mealTypes[mealIndex]['color'],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildButton(
                            'Add Food',
                            onPressed: authController.isLoading.value
                                ? null
                                : () async {
                                    if (foodName.isNotEmpty && calories > 0) {
                                      try {
                                        await AuthService().addMenuItem(
                                          dateTime:
                                              authController.selectedDate.value,
                                          foodName: foodName,
                                          kCal: int.parse(calories.toString()),
                                          category: _mealTypes[mealIndex]
                                              ["name"],
                                        );
                                        await authController.getMeals(
                                            authController.selectedDate.value);
                                        if (mounted) Navigator.pop(context);
                                      } catch (e) {
                                        print("Error adding food: $e");
                                      }
                                    }
                                  },
                            isLoading: authController.isLoading.value,
                            color: _mealTypes[mealIndex]['color'],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget _buildInputField(
    String label,
    IconData icon,
    Color color, {
    TextInputType? keyboardType,
    String? suffixText,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: color.withOpacity(0.8)),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon, color: color),
          suffixText: suffixText,
          suffixStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildButton(
    String text, {
    required VoidCallback? onPressed,
    bool isOutlined = false,
    bool isLoading = false,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : color,
          foregroundColor: isOutlined ? color : Colors.white,
          elevation: isOutlined ? 0 : 2,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: isOutlined ? BorderSide(color: color) : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  color: isOutlined ? color : Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: ColorHelper.primaryColor,
        title: const Text(
          'Daily Meals',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(
        () => RefreshIndicator(
          color: ColorHelper.primaryColor,
          onRefresh: () async {
            await authController.getMeals(authController.selectedDate.value);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeaderView(),
                SizedBox(height: 16.h),
                _buildCalorieStats(),
                SizedBox(height: 24.h),
                _buildMealList(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderView() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Meal Plan',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Keep track of your daily nutrition',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          _buildDatePicker(),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: authController.selectedDate.value,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: ColorHelper.primaryColor,
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          authController.selectedDate.value = pickedDate;
          authController.getMeals(authController.selectedDate.value);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorHelper.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 18.sp,
              color: ColorHelper.primaryColor,
            ),
            SizedBox(width: 8.w),
            Obx(
              () => Text(
                _getDisplayDate(authController.selectedDate.value),
                style: TextStyle(
                  color: ColorHelper.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCalorieItem(
                'Daily Goal',
                _calorieGoal,
                Icons.flag_rounded,
                ColorHelper.primaryColor,
              ),
              Container(
                height: 50.h,
                width: 1,
                color: Colors.grey[200],
              ),
              _buildCalorieItem(
                'Consumed',
                _consumedCalories,
                Icons.local_fire_department_rounded,
                ColorHelper.primaryColor,
              ),
              Container(
                height: 50.h,
                width: 1,
                color: Colors.grey[200],
              ),
              _buildCalorieItem(
                'Remaining',
                _remainingCalories,
                Icons.battery_charging_full_rounded,
                ColorHelper.primaryColor,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Progress',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${(_consumedCalories / _calorieGoal * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorHelper.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Stack(
                children: [
                  Container(
                    height: 12.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorHelper.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 12.h,
                    width: (MediaQuery.of(context).size.width - 88.w) *
                        (_consumedCalories / _calorieGoal),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorHelper.primaryColor,
                          ColorHelper.primaryColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorHelper.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieItem(
      String label, double value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28.sp),
        SizedBox(height: 8.h),
        Text(
          '${value.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildMealList() {
    return Column(
      children: List.generate(_mealTypes.length, (index) {
        final mealType = _mealTypes[index];
        final mealFoods = authController.mealList
            .where((meal) => meal['category'] == mealType['name'])
            .toList();

        return Container(
          margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: mealType['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        mealType['icon'],
                        color: mealType['color'],
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mealType['name'],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            mealType['time'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: mealType['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            '${getMealCalories(mealType['name'])} kcal',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: mealType['color'],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildActionButton(
                              Icons.add_rounded,
                              mealType['color'],
                              onPressed: () {
                                authController.mealName.value =
                                    mealType['name'];
                                _addFood(index);
                              },
                            ),
                            SizedBox(width: 12.w),
                            _buildActionButton(
                              Icons.camera_alt_rounded,
                              ColorHelper.primaryColor,
                              onPressed: () {
                                authController.isMealTracking.value = true;
                                authController.mealName.value =
                                    mealType['name'];
                                Get.to(() => const TakePhotoScreen());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (mealFoods.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Added Foods',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: mealType['color'],
                            ),
                          ),
                          Text(
                            '${mealFoods.length} items',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      ...mealFoods
                          .map((food) => _buildFoodItem(food, mealType)),
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActionButton(IconData icon, Color color,
      {required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 24.sp),
        color: color,
        padding: EdgeInsets.all(8.w),
        constraints: const BoxConstraints(),
        splashRadius: 24.r,
      ),
    );
  }

  Widget _buildFoodItem(
      Map<String, dynamic> food, Map<String, dynamic> mealType) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: mealType['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.restaurant_rounded,
              color: mealType['color'],
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['foodName'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Added for ${mealType['name'].toLowerCase()}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: mealType['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '${food['kCal']} kcal',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: mealType['color'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayDate(DateTime selectedDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime tomorrow = today.add(const Duration(days: 1));

    if (selectedDate.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (selectedDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else if (selectedDate.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow';
    } else {
      return '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    }
  }
}
