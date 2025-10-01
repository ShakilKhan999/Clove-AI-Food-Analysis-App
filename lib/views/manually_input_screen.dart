
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/views/result_screen.dart';
import 'package:get/get.dart';

import '../auth/controller/auth_controller.dart';
import '../helpers/color_helper.dart';
import '../models/food_analysis_model.dart';
import '../models/food_model.dart';
import '../models/nutrition_model.dart';

class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  String? selectedPortion;
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final List<String> portionSizes = [
    'Small',
    'Medium',
    'Large',
    'Extra Large',
  ];

  FoodAnalysisResponse _createMockResponse() {
    final foodName = foodNameController.text.trim();
    final portion = selectedPortion ?? 'Small';
    final notes = notesController.text.trim();

    return FoodAnalysisResponse(
      success: true,
      message: 'Success',
      data: FoodData(
        foodName: foodName.isEmpty ? 'Unknown Food' : foodName,
        description: notes.isEmpty ? 'Manually entered food item' : notes,
        portionSize: portion,
        nutrition: Nutrition(
          calories: '0',
          protein: '0g',
          carbohydrates: '0g',
          fat: '0g',
        ),
        glucoseImpact: 'Medium',
        recommendations: [
          'This is a manually entered food item.',
          'Consider measuring portions accurately for better glucose management.',
          'Monitor your glucose response to understand how this food affects you.',
          'Keep track of this food in your diary for future reference.',
        ],
      ),
    );
  }

  void _validateAndProceed() {
    if (foodNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a food name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final response = _createMockResponse();
    Get.to(
          () => ResultScreen(analysisResponse: response),
      transition: Transition.rightToLeft,
    );
  }
final AuthController authController=Get.find();
  // Original Mobile View
  Widget _buildMobileView() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()  {
            authController.homeRouteIndex.value=100;
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        toolbarHeight: 60.h,
        backgroundColor: const Color(0xff6254ff),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Manual Entry',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: _buildForm(isMobile: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern Desktop View
  Widget _buildDesktopView() {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1000.w),
            padding: EdgeInsets.all(32.sp),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  // Left Panel - Illustration/Info
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.all(32.sp),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ColorHelper.primaryColor,
                            Color(0xFF1976D2),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            color: Colors.white,
                            size: 48.sp,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'Manual Entry',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Enter your meal details manually to track your nutrition and glucose impact.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16.sp,
                              height: 1.5,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Container(
                            padding: EdgeInsets.all(16.sp),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.tips_and_updates_outlined,
                                  color: Colors.white,
                                  size: 24.sp,
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Text(
                                    'Be as specific as possible for better tracking and recommendations',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right Panel - Form
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(32.sp),
                      child: _buildForm(isMobile: false),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile) ...[
          Text(
            'Enter Manually',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please enter the details of your meal below.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24.h),
        ],

        Text(
          'Food Name',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: foodNameController,
          decoration: InputDecoration(
            hintText: 'Search for food...',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
        SizedBox(height: 20.h),

        Text(
          'Portion Size',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: selectedPortion,
          hint: Text(
            'Small',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14.sp,
            ),
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          items: portionSizes.map((String size) {
            return DropdownMenuItem<String>(
              value: size,
              child: Text(
                size,
                style: TextStyle(fontSize: 14.sp),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedPortion = newValue;
            });
          },
        ),
        SizedBox(height: 20.h),

        Text(
          'Notes (Optional)',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add any additional details...',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            contentPadding: EdgeInsets.all(16.sp),
          ),
        ),
        SizedBox(height: 32.h),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _validateAndProceed,
            style: ElevatedButton.styleFrom(
              backgroundColor:  ColorHelper.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 12.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Confirm',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
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
    return isDesktop ? _buildDesktopView() : _buildMobileView();
  }

  @override
  void dispose() {
    foodNameController.dispose();
    notesController.dispose();
    super.dispose();
  }
}