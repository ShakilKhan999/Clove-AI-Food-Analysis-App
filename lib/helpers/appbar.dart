import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/controllers/themeController.dart';
import 'package:get/get.dart';

import 'color_helper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  IconData icon = Icons.fastfood_outlined;

  CustomAppBar({super.key, this.icon = Icons.favorite_border});
  ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorHelper.primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(icon, color: Colors.white, size: 24.sp),
          Image.asset(
            'assets/images/clove.png',
            width: 24.w,
            height: 24.h,
          ),
          SizedBox(width: 8.w),
          Text(
            themeController.appName.value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
