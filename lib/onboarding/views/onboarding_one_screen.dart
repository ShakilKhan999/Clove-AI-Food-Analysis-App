import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/auth/views/signup_screen.dart';
import 'package:get/get.dart';

import '../../auth/views/info_screen_one.dart';
import '../../auth/views/login_screen.dart';
import '../../helpers/color_helper.dart';
import '../../helpers/common_components.dart';
import '../../helpers/space_helper.dart';

class OnboardingOneScreen extends StatelessWidget {
  const OnboardingOneScreen({super.key});

  Widget _buildDesktopView(BuildContext context) {
    return Row(
      children: [
        // Left side - Image or illustration
        Expanded(
          child: Container(
            color: ColorHelper.primaryColor.withOpacity(0.05),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 400.w,
                    height: 400.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Track Your Glucose Levels',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: ColorHelper.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Right side - Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonComponents().printText(
                  fontSize: 40.sp,
                  textData: 'Clove',
                  color: ColorHelper.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 24.h),
                CommonComponents().printText(
                  fontSize: 28.sp,
                  textData:
                      'Personalised Food Recipe Generator,\nTailored to you',
                  maxLine: 2,
                  color: ColorHelper.bgColor,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 16.h),
                CommonComponents().printText(
                  fontSize: 20.sp,
                  textData:
                      'Know how your body will respond -before you eat or shop',
                  maxLine: 3,
                  color: ColorHelper.bgColor,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 48.h),
                // Buttons
                SizedBox(
                  width: 300.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CommonComponents().commonButton(
                        text: 'Sign up',
                        onPressed: () {
                          Get.to(InfoScreenOne(),
                              transition: Transition.rightToLeft);
                        },
                      ),
                      SizedBox(height: 16.h),
                      CommonComponents().commonButton(
                        textColor: ColorHelper.primaryColor,
                        text: 'Login',
                        onPressed: () {
                          Get.offAll(LoginScreen());
                        },
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
        backgroundColor: Colors.white,
        body: _buildDesktopView(context),
      );
    }

    // Original mobile view code unchanged
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              // Middle content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonComponents().printText(
                    fontSize: 30,
                    textData: 'Clove',
                    textAlign: TextAlign.center,
                    color: ColorHelper.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  SpaceHelper.verticalSpace10,
                  CommonComponents().printText(
                    fontSize: 22,
                    textData:
                        'Personalised Food Recipe Generator,\nTailored to you',
                    textAlign: TextAlign.center,
                    maxLine: 2,
                    color: ColorHelper.bgColor,
                    fontWeight: FontWeight.w600,
                  ),
                  SpaceHelper.verticalSpace5,
                  CommonComponents().printText(
                    fontSize: 18,
                    textData:
                        'Know how your body will respond -before you eat or shop',
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
                    text: 'Sign up',
                    onPressed: () {
                      Get.to(SignupScreen(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                  SpaceHelper.verticalSpace5,
                  CommonComponents().commonButton(
                    textColor: ColorHelper.primaryColor,
                    text: 'Login',
                    onPressed: () {
                      Get.offAll(LoginScreen());
                    },
                    color: Colors.transparent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
