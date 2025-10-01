import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/controllers/themeController.dart';
import 'package:get/get.dart';

import '../../helpers/color_helper.dart';
import 'onboarding_one_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _slideAnimation;
  ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastEaseInToSlowEaseOut,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
    loadScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingOneScreen()),
      );
    }
  }

  Widget _buildMobileView() {
    return Center(
      child: FadeTransition(
        opacity: _animation,
        child: Image.asset(
          'assets/images/clove.png',
          // color: Colors.white,
          width: 250.w,
          height: 250.h,
        ),
      ),
    );
  }

  Widget _buildDesktopView() {
    return Row(
      children: [
        // Left side with logo
        Expanded(
          child: Container(
            color: Colors.white,
            child: Center(
              child: FadeTransition(
                opacity: _animation,
                child: Image.asset(
                  'assets/images/logo.png',
                  color: Colors.white,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
        ),
        // Right side with welcome text
        Expanded(
          child: Container(
            color: Colors.white,
            child: Center(
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: FadeTransition(
                      opacity: _animation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome to ${themeController.appName.value}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: ColorHelper.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your journey begins here',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if the screen width is larger than 1024 logical pixels
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      backgroundColor:
          // isDesktop
          //     ? Colors.transparent
          //     :
          ColorHelper.whiteColor,
      body: isDesktop ? _buildDesktopView() : _buildMobileView(),
    );
  }
}
