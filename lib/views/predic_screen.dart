
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/bottom_nevigation/views/mobile_bottom.dart';
import 'package:food_recepi/controllers/themeController.dart';
import 'package:food_recepi/views/result_screen.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../auth/controller/auth_controller.dart';
import '../helpers/color_helper.dart';
import '../models/food_analysis_model.dart';
import 'meal_screen.dart';

class PredicScreen extends StatefulWidget {
  final FoodAnalysisResponse? analysisResponse;

  const PredicScreen({
    Key? key,
    required this.analysisResponse,
  }) : super(key: key);

  @override
  State<PredicScreen> createState() => _PredicScreenState();
}

class _PredicScreenState extends State<PredicScreen>
    with SingleTickerProviderStateMixin {
  final AuthController controller = Get.put(AuthController());
  double _loadingPercent = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Total animation duration
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {
          _loadingPercent = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {


          if(widget.analysisResponse==null)
            {
              Get.offAll(CustomBottomNavBar());
            }
          else
            {

              // Navigate to ResultScreen when animation completes
              Get.off(
                    () => controller.isMealTracking.value?
                MealTrackerScreen(): ResultScreen(analysisResponse: widget.analysisResponse!),
                transition: Transition.cupertino,
              );
              //controller.isMealTracking.value=false;
            }
        }
      });

    // Start the animation after a brief delay
    Future.delayed(Duration(milliseconds: 500), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String get _loadingText {
    if (_loadingPercent < 0.3) {
      return 'Analyzing nutritional content...';
    } else if (_loadingPercent < 0.6) {
      return 'Calculating glucose impact...';
    } else if (_loadingPercent < 0.9) {
      return 'Preparing recommendations...';
    } else {
      return 'Almost ready...';
    }
  }
  ThemeController themeController=Get.put(ThemeController());

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
                themeController.appName.value,
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
                      animation: false,
                      percent: _loadingPercent,
                      center: Text(
                        "${(_loadingPercent * 100).toInt()}%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: ColorHelper.primaryColor,
                    ),
                    SizedBox(height: 40.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        _loadingText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black54,
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
}
