
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../bottom_nevigation/views/mobile_bottom.dart';
import '../helpers/color_helper.dart';
import '../models/food_analysis_model.dart';
import 'alternative_screen.dart';

class WhyResultScreen extends StatelessWidget {
  final FoodAnalysisResponse analysisResponse;

  const WhyResultScreen({
    Key? key,
    required this.analysisResponse,
  }) : super(key: key);

  Color _getImpactColor() {
    switch (analysisResponse.data?.glucoseImpact.toLowerCase()) {
      case 'good':
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
      case 'heigh':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final nutrition = analysisResponse.data?.nutrition;
    final impactColor = _getImpactColor();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.sp),
              color:  ColorHelper.primaryColor,
              child: Text(
                'FoodRecipe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why This Result?',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Nutrition Profile Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nutrition Profile Breakdown:',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            _buildNutritionRow('Carbohydrates:',
                                nutrition?.carbohydrates ?? '0g'),
                            _buildNutritionRow(
                                'Protein:', nutrition?.protein ?? '0g'),
                            _buildNutritionRow(
                                'Calories:', nutrition?.calories ?? '0'),
                            _buildNutritionRow('Fat:', nutrition?.fat ?? '0g'),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Personalized Explanation
                      Text(
                        'Personalised Explanation:',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      _buildExplanationCard(
                        title:
                            'Impact Level: ${analysisResponse.data?.glucoseImpact ?? "Medium"}',
                        content: analysisResponse.data?.recommendations
                                ?.join('\n\n') ??
                            'No specific recommendations available.',
                        color: impactColor,
                      ),

                      SizedBox(height: 24.h),

                      // Bottom Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(
                                  () => AlternativesScreen(),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  ColorHelper.primaryColor,
                                padding: EdgeInsets.symmetric(vertical: 12.sp),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                'Show Me Alternatives',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => CustomBottomNavBar(),
                                    transition: Transition.rightToLeft);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  ColorHelper.primaryColor,
                                padding: EdgeInsets.symmetric(vertical: 12.sp),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                'Log Another Meal',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: _getImpactColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard({
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
