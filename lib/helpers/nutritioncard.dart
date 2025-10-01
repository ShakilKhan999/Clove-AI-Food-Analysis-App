
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/nutrition_model.dart';
import 'color_helper.dart';

class NutritionCard extends StatelessWidget {
  final Nutrition nutrition;

  const NutritionCard({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: ColorHelper.primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Nutrition Information',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildNutritionRow('Calories', nutrition.calories),
            _buildDivider(),
            _buildNutritionRow('Carbohydrates', nutrition.carbohydrates),
            _buildDivider(),
            _buildNutritionRow('Protein', nutrition.protein),
            _buildDivider(),
            _buildNutritionRow('Fat', nutrition.fat),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorHelper.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      height: 1.h,
    );
  }
}
