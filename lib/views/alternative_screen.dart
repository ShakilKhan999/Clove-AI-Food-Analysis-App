
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../bottom_nevigation/views/mobile_bottom.dart';
import '../helpers/color_helper.dart';

class AlternativesScreen extends StatelessWidget {
  const AlternativesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.eco,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'FoodRecipe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
                      Center(
                        child: Text(
                          'Better Choices for Balanced\nGlucose',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Primary Suggestions
                      Row(
                        children: [
                          Text(
                            'Primary Suggestions - ',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Select One',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: ColorHelper.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Suggestion Cards
                      _buildSuggestionCard(
                        'Swap to Macro Low carb Bread',
                        'Lower carb and higher fiber\ncontent to reduce the spike.',
                        'New GL: 40',
                        'Available: Woolworths',
                        'assets/bread1.png',
                      ),
                      SizedBox(height: 12.h),
                      _buildSuggestionCard(
                        'Swap to Burgen Low carb Bread',
                        'Lower carb and higher fiber\ncontent to reduce the spike.',
                        'New GL: 40',
                        'Available: Coles, Woolworths, IGA',
                        'assets/bread2.png',
                      ),
                      SizedBox(height: 24.h),

                      // Secondary Suggestions
                      Text(
                        'Secondary Suggestions',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildBulletPoint(
                          'Add avocado or for healthy fats to moderate absorption'),
                      _buildBulletPoint(
                          'Include a side of steamed broccoli for added fiber.'),
                      _buildBulletPoint(
                          'Pair with lean protein like chicken breast or eggs.'),
                      SizedBox(height: 24.h),

                      // Comparison Table
                      Text(
                        'Comparison Table',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildComparisonTable(),
                      SizedBox(height: 24.h),

                      // Done Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(CustomBottomNavBar(),
                                transition: Transition.rightToLeftWithFade);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  ColorHelper.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 12.sp),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Done',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(String title, String description, String gl,
      String availability, String imagePath) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Image.asset('assets/images/b1.jpg')),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  gl,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  availability,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 14.sp)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
        },
        children: [
          _buildTableRow('', 'Current Food', 'Suggested\nAlternative',
              isHeader: true),
          _buildTableRow('Total Carbs:', '45g', '30g'),
          _buildTableRow('Sugar:', '12g', '5g'),
          _buildTableRow('Fibre:', '3g', '6g'),
          _buildTableRow('Protein:', '2g', '5g'),
          _buildTableRow('Likely Spike:', 'High', 'Low'),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String current, String suggested,
      {bool isHeader = false}) {
    TextStyle style = TextStyle(
      fontSize: 12.sp,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      color: isHeader ? Colors.black : Colors.grey[700],
    );

    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey[100] : Colors.white,
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(8.sp),
          child: Text(label, style: style),
        ),
        Padding(
          padding: EdgeInsets.all(8.sp),
          child: Text(current, style: style),
        ),
        Padding(
          padding: EdgeInsets.all(8.sp),
          child: Text(suggested, style: style),
        ),
      ],
    );
  }
}
