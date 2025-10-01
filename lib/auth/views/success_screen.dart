
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/auth/views/signup_screen.dart';
import 'package:get/get.dart';

import '../../helpers/color_helper.dart';
import '../../helpers/common_components.dart';
import '../../helpers/space_helper.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    textData: 'Success!',
                    textAlign: TextAlign.center,
                    maxLine: 2,
                    color: ColorHelper.bgColor,
                    fontWeight: FontWeight.bold,
                  ),
                  SpaceHelper.verticalSpace5,
                  CommonComponents().printText(
                    fontSize: 18,
                    textData:
                        'Your Glucose pridiction tool is ready.\n Let’s head to your dashboard and get \nstarted!.',
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
                    text: 'Next',
                    onPressed: () {
                      Get.to(SignupScreen(),
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
