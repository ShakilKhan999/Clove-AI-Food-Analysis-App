import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_helper.dart';

class GlucoseImpactCard extends StatelessWidget {
  final String glucoseImpact;

  const GlucoseImpactCard({
    Key? key,
    required this.glucoseImpact,
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
                  Icons.local_hospital,
                  color: ColorHelper.primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Glucose Impact',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              glucoseImpact,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
