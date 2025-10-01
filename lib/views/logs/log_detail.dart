import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'log_model.dart'; // Add this package to pubspec.yaml

class LogDetailScreen extends StatelessWidget {
  final LogModel log;

  LogDetailScreen({required this.log});

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Meal Details',
          style: TextStyle(color: Colors.black, fontSize: 18.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              SizedBox(height: 16.h),
              _buildNutritionCard(),
              SizedBox(height: 16.h),
              _buildMacrosPieChart(),
              SizedBox(height: 16.h),
              _buildRecommendationsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                log.foodData!.foodName,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: _getImpactColor(log.foodData!.glucoseImpact)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  log.foodData!.glucoseImpact,
                  style: TextStyle(
                    color: _getImpactColor(log.foodData!.glucoseImpact),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            _formatDateTime(log.logTime),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            log.foodData!.description,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Portion: ${log.foodData!.portionSize}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Facts',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          _buildNutrientRow(
            icon: Icons.local_fire_department,
            label: 'Calories',
            value: log.foodData!.nutrition.calories,
            unit: 'kcal',
            color: Colors.orange,
          ),
          _buildNutrientRow(
            icon: Icons.grain,
            label: 'Carbs',
            value: log.foodData!.nutrition.carbohydrates,
            unit: 'g',
            color: Colors.blue,
          ),
          _buildNutrientRow(
            icon: Icons.fitness_center,
            label: 'Protein',
            value: log.foodData!.nutrition.protein,
            unit: 'g',
            color: Colors.red,
          ),
          _buildNutrientRow(
            icon: Icons.water_drop,
            label: 'Fat',
            value: log.foodData!.nutrition.fat,
            unit: 'g',
            color: Colors.yellow[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[800],
            ),
          ),
          Spacer(),
          Text(
            '$value$unit',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosPieChart() {
    final nutrition = log.foodData!.nutrition;

    // Helper function to extract numbers from strings
    double extractNumber(String text) {
      final RegExp regex = RegExp(r'(\d+(\.\d+)?)');
      final match = regex.firstMatch(text);
      return match != null ? double.parse(match.group(0)!) : 0.0;
    }

    // Extract values for macronutrients
    final carbs = extractNumber(nutrition.carbohydrates);
    final protein = extractNumber(nutrition.protein);
    final fat = extractNumber(nutrition.fat);
    final total = carbs + protein + fat;

    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Macronutrients Distribution',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 200.h,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: Colors.blue,
                    value: carbs,
                    title: '${((carbs / total) * 100).toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: protein,
                    title: '${((protein / total) * 100).toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.yellow[700]!,
                    value: fat,
                    title: '${((fat / total) * 100).toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Carbs', Colors.blue),
              SizedBox(width: 24.w),
              _buildLegendItem('Protein', Colors.red),
              SizedBox(width: 24.w),
              _buildLegendItem('Fat', Colors.yellow[700]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsCard() {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ...log.foodData!.recommendations.map((recommendation) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.tips_and_updates,
                  color: Colors.amber,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    recommendation,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Color _getImpactColor(String impact) {
    impact = impact.toLowerCase();
    if (impact.contains('low')) return Colors.green;
    if (impact.contains('moderate')) return Colors.orange;
    if (impact.contains('high')) return Colors.red;
    return Colors.grey;
  }
}