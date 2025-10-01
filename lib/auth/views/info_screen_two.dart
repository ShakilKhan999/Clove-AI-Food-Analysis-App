
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../helpers/color_helper.dart';
import '../../helpers/common_components.dart';
import '../../helpers/space_helper.dart';
import 'info_screen_three.dart';

class InfoScreenTwo extends StatelessWidget {
  const InfoScreenTwo({super.key});

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
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
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
                          Icons.trending_up_rounded,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Take Control',
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
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.h),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        color: ColorHelper.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        Icons.bar_chart_rounded,
                        size: 80.sp,
                        color: ColorHelper.primaryColor,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    CommonComponents().printText(
                      fontSize: 36.sp,
                      textData: 'Ready to Take,\nControl?',
                      textAlign: TextAlign.center,
                      maxLine: 2,
                      color: ColorHelper.bgColor,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 16.h),
                    CommonComponents().printText(
                      fontSize: 20.sp,
                      textData: "Let's make your Glucose Predictor\nUniquely Yours!",
                      textAlign: TextAlign.center,
                      maxLine: 3,
                      color: ColorHelper.bgColor,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 40.h),
                    CommonComponents().commonButton(
                      text: 'Gets Started',
                      onPressed: () {
                        Get.to(InfoScreenThree(),
                            transition: Transition.rightToLeft);
                      },
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonComponents().printText(
                    fontSize: 30,
                    textData: 'Ready to Take,\nControl?',
                    textAlign: TextAlign.center,
                    maxLine: 2,
                    color: ColorHelper.bgColor,
                    fontWeight: FontWeight.bold,
                  ),
                  SpaceHelper.verticalSpace5,
                  CommonComponents().printText(
                    fontSize: 18,
                    textData:
                    "Let's make your Glucose Predictor \nUniquely Yours!",
                    textAlign: TextAlign.center,
                    maxLine: 3,
                    color: ColorHelper.bgColor,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              const Spacer(),
              // Bottom buttons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonComponents().commonButton(
                    text: 'Gets Started',
                    onPressed: () {
                      Get.to(InfoScreenThree(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                  SpaceHelper.verticalSpace5,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}