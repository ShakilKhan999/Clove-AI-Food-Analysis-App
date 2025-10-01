
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/controllers/themeController.dart';
import 'package:food_recepi/views/why_screen.dart';
import 'package:get/get.dart';

import '../helpers/color_helper.dart';
import '../models/food_analysis_model.dart';
import 'alternative_screen.dart';

class ResultScreen extends StatelessWidget {
  final FoodAnalysisResponse analysisResponse;

   ResultScreen({
    super.key,
    required this.analysisResponse,
  });

  void _debugPrintImpact() {
    print('Raw glucoseImpact: ${analysisResponse.data?.glucoseImpact}');
  }

  Color get _resultColor {
    _debugPrintImpact();
    final impact = analysisResponse.data?.glucoseImpact.toLowerCase().trim() ?? '';
    print('Processed impact: $impact');

    if (impact.contains('low') || impact.contains('good')) {
      return Colors.green;
    } else if (impact.contains('medium') || impact.contains('moderate')) {
      return Color(0xFFFFBE00);
    } else if (impact.contains('high')) {
      return Colors.red;
    }
    return Colors.green;
  }

  String get _resultText {
    final impact = analysisResponse.data?.glucoseImpact.toLowerCase().trim() ?? '';
    if (impact.contains('low') || impact.contains('good')) {
      return 'Good to go';
    } else if (impact.contains('medium') || impact.contains('moderate')) {
      return 'Moderate impact';
    } else if (impact.contains('high')) {
      return 'High impact';
    }
    return 'Good to go';
  }

  String get _descriptionText {
    final impact = analysisResponse.data?.glucoseImpact.toLowerCase().trim() ?? '';
    if (impact.contains('low') || impact.contains('good')) {
      return 'This is a good choice for stable glucose levels.';
    } else if (impact.contains('medium') || impact.contains('moderate')) {
      return 'This food may cause moderate glucose fluctuations.';
    } else if (impact.contains('high')) {
      return 'This food may significantly affect your glucose levels.';
    }
    return 'This is a good choice for stable glucose levels.';
  }
  ThemeController themeController=Get.put(ThemeController());

  Widget _buildMobileView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.sp),
              color:  ColorHelper.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    themeController.appName.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Keep the original mobile content exactly the same
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Glucose Prediction',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      width: 200.w,
                      height: 200.w,
                      decoration: BoxDecoration(
                        color: _resultColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _resultColor.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _resultText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      _descriptionText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      width: 200.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => WhyResultScreen(analysisResponse: analysisResponse),
                              transition: Transition.rightToLeft);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 12.sp),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Why?',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 200.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => AlternativesScreen(),
                              transition: Transition.rightToLeft);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 12.sp),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Show Me Alternatives',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopView() {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200.w),
          padding: EdgeInsets.all(32.sp),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(24.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.analytics_outlined,
                        color: ColorHelper.primaryColor,
                        size: 32.sp),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analysis Results',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Food: ${analysisResponse.data?.foodName ?? "Unknown"}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Main Content
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Panel - Result
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(32.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 240.w,
                              height: 240.w,
                              decoration: BoxDecoration(
                                color: _resultColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _resultColor,
                                  width: 8.w,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _resultColor == Colors.green
                                          ? Icons.check_circle_outline
                                          : _resultColor == Color(0xFFFFBE00)
                                          ? Icons.info_outline
                                          : Icons.warning_outlined,
                                      color: _resultColor,
                                      size: 48.sp,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      _resultText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _resultColor,
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),
                            Text(
                              _descriptionText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 24.w),

                    // Right Panel - Details & Actions
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(32.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nutritional Information',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            _buildNutritionItem('Calories',
                                analysisResponse.data?.nutrition.calories ?? "N/A"),
                            _buildNutritionItem('Protein',
                                analysisResponse.data?.nutrition.protein ?? "N/A"),
                            _buildNutritionItem('Carbohydrates',
                                analysisResponse.data?.nutrition.carbohydrates ?? "N/A"),
                            _buildNutritionItem('Fat',
                                analysisResponse.data?.nutrition.fat ?? "N/A"),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(Icons.help_outline),
                                  label: Text('Why This Result?'),
                                  onPressed: () {
                                    Get.to(() => WhyResultScreen(
                                        analysisResponse: analysisResponse),
                                        transition: Transition.rightToLeft);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: ColorHelper.primaryColor,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                      horizontal: 24.w,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      side: BorderSide(
                                        color: ColorHelper.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton.icon(
                                  icon: Icon(Icons.swap_horiz),
                                  label: Text('Show Alternatives'),
                                  onPressed: () {
                                    Get.to(() => AlternativesScreen(),
                                        transition: Transition.rightToLeft);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorHelper.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                      horizontal: 24.w,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Container(
        margin: EdgeInsets.only(bottom: 16.h),
    padding: EdgeInsets.all(16.sp),
    decoration: BoxDecoration(
    color: Colors.grey[50],
    borderRadius: BorderRadius.circular(8.r),
    border: Border.all(color: Colors.grey[200]!),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    label,
    style: TextStyle(
    fontSize: 16.sp,
      color: Colors.grey[700],
    ),
    ),
      Text(
        value,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    ],
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 1024) {
      ScreenUtil.init(
        context,
        designSize: const Size(1440, 900),
        minTextAdapt: true,
        splitScreenMode: true,
      );
      return _buildDesktopView();
    } else {
      ScreenUtil.init(
        context,
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
      );
      return _buildMobileView();
  }}
}