
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../helpers/appbar.dart';
import '../../helpers/color_helper.dart';
import '../../helpers/common_components.dart';
import '../controller/auth_controller.dart';
import 'info_screen_four.dart';

class InfoScreenThree extends StatelessWidget {
  InfoScreenThree({super.key});

  final AuthController controller = Get.put(AuthController());

  Widget _buildDesktopTextField(TextEditingController controller, String hintText) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
      ),
    );
  }

  Widget _buildDesktopSlider({
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
    required String label,
    String? unit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)}${unit ?? ""}',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorHelper.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: ColorHelper.primaryColor,
            inactiveTrackColor: Colors.grey[200],
            thumbColor: Colors.white,
            overlayColor: ColorHelper.primaryColor.withOpacity(0.2),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.r),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 24.r),
            trackHeight: 4.h,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopRadioGroup() {
    return Obx(() => Column(
      children: controller.activityLevels.map((level) => Container(
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.activityLevel.value == level
                ? ColorHelper.primaryColor
                : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: RadioListTile<String>(
          title: Text(
            level,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          value: level,
          groupValue: controller.activityLevel.value,
          onChanged: (value) => controller.activityLevel.value = value!,
          activeColor: ColorHelper.primaryColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
      )).toList(),
    ));
  }

  Widget _buildDesktopCheckboxGroup() {
    return Obx(() => Column(
      children: controller.exerciseTypes.entries.map((entry) => Container(
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: entry.value ? ColorHelper.primaryColor : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: CheckboxListTile(
          title: Text(
            entry.key,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          value: entry.value,
          onChanged: (value) => controller.updateExerciseType(entry.key, value),
          activeColor: ColorHelper.primaryColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
      )).toList(),
    ));
  }

  Widget _buildFormSection(String title, Widget child, {String? description}) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ColorHelper.bgColor,
            ),
          ),
          if (description != null) ...[
            SizedBox(height: 4.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _buildMobileView() {
    // Original mobile view code here
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tell Us About Yourself',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Age Input
                    _buildLabel('Age:'),

                    TextField(
                      controller: controller.ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '18',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Biometrics Input
                    _buildLabel('Biometrics:'),
                    TextField(
                      controller: controller.biometricsController,
                      decoration: InputDecoration(
                        hintText: 'Enter biometrics',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Activity Level
                    _buildLabel('Activity Level:'),
                    Obx(() => Column(
                      children: controller.activityLevels
                          .map(
                            (level) => RadioListTile<String>(
                          title: Text(level),
                          value: level,
                          groupValue: controller.activityLevel.value,
                          onChanged: (value) =>
                          controller.activityLevel.value = value!,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                          .toList(),
                    )),
                    SizedBox(height: 16.h),

                    // Height Slider
                    _buildLabel('Height:'),
                    Obx(() => Column(
                      children: [
                        Slider(
                          value: controller.height.value,
                          min: 100,
                          max: 220,
                          onChanged: (value) =>
                          controller.height.value = value,
                        ),
                        Text(
                          '${controller.height.value.toStringAsFixed(1)} cm',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                    SizedBox(height: 16.h),

                    // Weight Slider
                    _buildLabel('Weight:'),
                    Obx(() => Column(
                      children: [
                        Slider(
                          value: controller.weight.value,
                          min: 30,
                          max: 150,
                          onChanged: (value) =>
                          controller.weight.value = value,
                        ),
                        Text(
                          '${controller.weight.value.toStringAsFixed(1)} kg',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                    SizedBox(height: 16.h),

                    // Exercise Type
                    _buildLabel('Exercise Type (Optional):'),
                    Obx(() => Column(
                      children: controller.exerciseTypes.entries
                          .map(
                            (entry) => CheckboxListTile(
                          title: Text(entry.key),
                          value: entry.value,
                          onChanged: (value) => controller
                              .updateExerciseType(entry.key, value),
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                          .toList(),
                    )),
                    SizedBox(height: 16.h),

                    // Fasting Blood Glucose
                    _buildLabel('Fasting Blood Glucose:'),
                    TextField(
                      controller: controller.fastingGlucoseController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter value',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Don\'t know? Skip for now',
                        style: TextStyle(
                          color: ColorHelper.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Sleep Patterns
                    _buildLabel('Sleep Patterns:'),
                    Text('Average Hours of Sleep:'),
                    Obx(() => Column(
                      children: [
                        Slider(
                          value: controller.sleepHours.value,
                          min: 4,
                          max: 12,
                          onChanged: (value) =>
                          controller.sleepHours.value = value,
                        ),
                        Text(
                          '${controller.sleepHours.value.toStringAsFixed(1)} hours',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),

                    SizedBox(height: 8.h),
                    Text('Quality of Sleep:'),
                    TextField(
                      controller: controller.sleepQualityController,
                      decoration: InputDecoration(
                        hintText: 'Good',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Stress Levels
                    _buildLabel('Stress Levels:'),
                    Obx(() => Column(
                      children: [
                        Slider(
                          value: controller.stressLevel.value,
                          min: 0,
                          max: 10,
                          onChanged: (value) =>
                          controller.stressLevel.value = value,
                        ),
                        Text(
                          'Level: ${controller.stressLevel.value.toStringAsFixed(1)}',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                    SizedBox(height: 24.h),

                    // Next Button
                    CommonComponents().commonButton(
                        text: "Next",
                        onPressed: () {
                          Get.to(InfoScreenFour(),
                              transition: Transition.rightToLeft);
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDesktopSidePanel() {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24.sp),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: ColorHelper.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: ColorHelper.primaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Profile Setup',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorHelper.bgColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              children: [
                _buildSideMenuItem('Basic Info', true),
                _buildSideMenuItem('Health Metrics', false),
                _buildSideMenuItem('Activity', false),
                _buildSideMenuItem('Sleep & Stress', false),
                _buildSideMenuItem('Review', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenuItem(String title, bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? ColorHelper.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        leading: Icon(
          isActive ? Icons.check_circle : Icons.circle_outlined,
          color: isActive ? ColorHelper.primaryColor : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? ColorHelper.primaryColor : Colors.grey[700],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isActive,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  Widget _buildDesktopView() {
    return Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
    body: Row(
    children: [
    _buildDesktopSidePanel(),
    Expanded(
    child: Container(
    padding: EdgeInsets.all(40.sp),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Basic Information',
    style: TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: ColorHelper.bgColor,
    ),
    ),
    SizedBox(height: 8.h),
    Text(
    'Step 1 of 5 - Tell us about yourself',
    style: TextStyle(
    fontSize: 16.sp,
    color: Colors.grey[600],
    ),
    ),
    ],
    ),
    Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20.r),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    ),
    ],
    ),
    child: Row(
    children: [
    Icon(Icons.help_outline, color: Colors.grey),
    SizedBox(width: 8.w),
    Text('Need help?'),
    ],
    ),
    ),
    ],
    ),
    SizedBox(height: 32.h),
    Expanded(
    child: Container(
    padding: EdgeInsets.all(32.sp),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16.r),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    ),
    ],
    ),
    child: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(
    child: _buildFormSection(
    'Age',
    _buildDesktopTextField(controller.ageController, '18'),
    ),
    ),
    SizedBox(width: 24.w),
    Expanded(
    child: _buildFormSection(
    'Biometrics',
    _buildDesktopTextField(
    controller.biometricsController,
    'Enter biometrics',
    ),
    ),
    ),
    ],
    ),
    _buildFormSection(
    'Activity Level',
    _buildDesktopRadioGroup(),
    description: 'Select your typical activity level',
    ),
    Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(
    child: _buildFormSection(
    'Height',
    Obx(() => _buildDesktopSlider(
    value: controller.height.value,
    min: 100,
    max: 220,
    onChanged: (value) => controller.height.value = value,
    label: 'Height',
    unit: ' cm',
    )),
    ),
    ),
    SizedBox(width: 24.w),
    Expanded(
    child: _buildFormSection(
    'Weight',
    Obx(() => _buildDesktopSlider(
    value: controller.weight.value,
    min: 30,
    max: 150,
    onChanged: (value) => controller.weight.value = value,
    label: 'Weight',
    unit: ' kg',
    )),
    ),
    ),
    ],
    ),
    _buildFormSection(
    'Exercise Type',
    _buildDesktopCheckboxGroup(),
    description: 'Select all that apply (Optional)',
    ),
    _buildFormSection(
    'Fasting Blood Glucose',
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    _buildDesktopTextField(
    controller.fastingGlucoseController,
    'Enter value',
    ),
    SizedBox(height: 8.h),
    TextButton(
    onPressed: () {},
    style: TextButton.styleFrom(
    padding: EdgeInsets.zero,
    ),
    child: Text(
    'Don\'t know? Skip for now',
    style: TextStyle(
    color: ColorHelper.primaryColor,
    decoration: TextDecoration.underline,
    ),
    ),
    ),
    ],
    ),
    ),
    _buildFormSection(
    'Sleep Patterns',
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Obx(() => _buildDesktopSlider(
    value: controller.sleepHours.value,
    min: 4,
      max: 12,
      onChanged: (value) => controller.sleepHours.value = value,
      label: 'Average Hours of Sleep',
      unit: ' hours',
    )),
      SizedBox(height: 16.h),
      Text(
        'Sleep Quality',
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8.h),
      _buildDesktopTextField(
        controller.sleepQualityController,
        'Good',
      ),
    ],
    ),
    ),
      _buildFormSection(
        'Stress Level',
        Obx(() => _buildDesktopSlider(
          value: controller.stressLevel.value,
          min: 0,
          max: 10,
          onChanged: (value) => controller.stressLevel.value = value,
          label: 'Current Stress Level',
        )),
        description: 'Rate your typical stress level from 0 to 10',
      ),
    ],
    ),
    ),
    ),
    ),
      SizedBox(height: 24.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text(
              'Back',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorHelper.primaryColor,
                  Color(0xFF1976D2),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: ColorHelper.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Get.to(InfoScreenFour(), transition: Transition.rightToLeft);
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
    ),
    ),
    ),
    ],
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;


    return isDesktop ? _buildDesktopView() : _buildMobileView();
  }
}