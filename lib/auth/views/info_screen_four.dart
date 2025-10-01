
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/auth/views/success_screen.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../helpers/color_helper.dart';

class InfoScreenFour extends StatefulWidget {
  InfoScreenFour({super.key});

  @override
  State<InfoScreenFour> createState() => _InfoScreenFourState();
}

class _InfoScreenFourState extends State<InfoScreenFour>
    with SingleTickerProviderStateMixin {
  //final AuthController controller = Get.put(AuthController());
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Total animation duration
    );

    // Create progress animation from 0.7 to 1.0
    _progressAnimation =
        Tween<double>(begin: 0.7, end: 1.0).animate(_animationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && !_hasNavigated) {
              _hasNavigated = true;
              Future.delayed(Duration(milliseconds: 500), () {
                Get.to(() => SuccessScreen(), transition: Transition.cupertino);
              });
            }
          });

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: const BoxDecoration(
                color: ColorHelper.primaryColor,
              ),
              child: Text(
                'FoodRecipe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Light Blue Background
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.blue[50],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Personalizing Your\nPredictor...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 13.0,
                      animation: false, // We're handling animation manually
                      percent: _progressAnimation.value,
                      center: Text(
                        "${(_progressAnimation.value * 100).toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: ColorHelper.primaryColor,
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      'Calibrating your glucose predictor...',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
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
}
