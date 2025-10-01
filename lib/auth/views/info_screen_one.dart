
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/controllers/themeController.dart';
import 'package:get/get.dart';

import '../../helpers/color_helper.dart';
import '../../helpers/common_components.dart';
import '../../helpers/space_helper.dart';
import '../controller/auth_controller.dart';
import 'info_screen_two.dart';

class InfoScreenOne extends StatelessWidget {
  InfoScreenOne({super.key});
  final AuthController controller = Get.put(AuthController());
  final ThemeController themeController = Get.put(ThemeController());

  Widget _buildDesktopView() {
    return SafeArea(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800.w),
          margin: EdgeInsets.all(32.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorHelper.primaryColor,
                        Color(0xFF1976D2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        themeController.appName.value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tell us about yourself',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Select all options that apply to you',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Obx(
                          () => Column(
                        children: controller.checkboxValues.entries.map((entry) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CheckboxListTile(
                              title: Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              value: entry.value,
                              onChanged: (bool? value) {
                                controller.updateCheckbox(entry.key, value);
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Center(
                      child: CommonComponents().commonButton(
                        text: 'Next',
                        onPressed: () {
                          Get.to(const InfoScreenTwo(),
                              transition: Transition.rightToLeft);
                        },
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

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for desktop view
    if (MediaQuery.of(context).size.width >= 1024) {
      ScreenUtil.init(
        context,
        designSize: const Size(1440, 900),
        minTextAdapt: true,
        splitScreenMode: true,
      );
    }

    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: _buildDesktopView(),
      );
    }

    // Original mobile view code unchanged
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ColorHelper.primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, color: Colors.white, size: 24.sp),
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
            ),
            // Checkboxes
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Obx(
                      () => Column(
                    children: controller.checkboxValues.entries.map((entry) {
                      return CheckboxListTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black87,
                          ),
                        ),
                        value: entry.value,
                        onChanged: (bool? value) {
                          controller.updateCheckbox(entry.key, value);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            // Next Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonComponents().commonButton(
                  text: 'Next',
                  onPressed: () {
                    Get.to(const InfoScreenTwo(),
                        transition: Transition.rightToLeft);
                  }),
            ),
            SpaceHelper.verticalSpace10
          ],
        ),
      ),
    );
  }
}