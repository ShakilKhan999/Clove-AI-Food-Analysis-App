
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/views/result_screen.dart';
import 'package:get/get.dart';

import '../auth/controller/auth_controller.dart';
import '../helpers/color_helper.dart';
import '../helpers/common_components.dart';
import '../models/food_analysis_model.dart';
import '../models/food_model.dart';
import '../models/nutrition_model.dart';

class BarcodeScanScreen extends StatefulWidget {
  const BarcodeScanScreen({super.key});

  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  String _productName = '';
  String _portionSize = '';
  String _barcodeNumber = '';

  // Create mock response based on scanned product
  FoodAnalysisResponse _createMockResponse() {
    return FoodAnalysisResponse(
      success: true,
      message: 'Success',
      data: FoodData(
        foodName: _productName.isEmpty ? 'Unknown Product' : _productName,
        description: 'Scanned product with barcode: $_barcodeNumber',
        portionSize: _portionSize.isEmpty ? 'Standard serving' : _portionSize,
        nutrition: Nutrition(
          calories: '120',
          protein: '4g',
          carbohydrates: '23g',
          fat: '2g',
        ),
        glucoseImpact: 'Medium',
        recommendations: [
          'This is a scanned product.',
          'Standard portion size recommendation applies.',
          'Monitor your glucose response to understand how this food affects you.',
          'Consider pairing with protein or healthy fats to moderate glucose impact.',
        ],
      ),
    );
  }

  // Future<void> startBarcodeScan() async {
  //   try {
  //     String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //       '#2196F3',
  //       'Cancel',
  //       true,
  //       ScanMode.BARCODE,
  //     );
  //
  //     if (barcodeScanRes != '-1') {
  //       setState(() {
  //         _barcodeNumber = barcodeScanRes;
  //         // Simulating product lookup based on barcode
  //         _productName = 'Whole Grain Bread';
  //         _portionSize = '2 Slices (56g)';
  //       });
  //     }
  //   } catch (e) {
  //     print('Failed to scan barcode: $e');
  //     Get.snackbar(
  //       'Error',
  //       'Failed to scan barcode. Please try again.',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }

  void _proceedToResults() {
    if (_productName.isEmpty) {
      Get.snackbar(
        'Error',
        'Please scan a product first',
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

  Widget _buildDesktopView() {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, color: ColorHelper.primaryColor, size: 28.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'Barcode Scanner',
                    style: TextStyle(
                      color: ColorHelper.primaryColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 800.w),
                  margin: EdgeInsets.all(32.sp),
                  padding: EdgeInsets.all(40.sp),
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
                      // Icon and Title
                      Icon(
                        Icons.qr_code_scanner,
                        size: 80.sp,
                        color: ColorHelper.primaryColor.withOpacity(0.2),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Scan Product Barcode',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Scan the barcode on your product to get nutritional information',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Scan button
                      if (_productName.isEmpty)
                        SizedBox(
                          width: 250.w,
                          child: CommonComponents().commonButton(
                            text: "Start Scanning",
                            onPressed: (){},
                          ),
                        ),

                      // Results section
                      if (_productName.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.sp),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.grey[200]!,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: ColorHelper.primaryColor,
                                    size: 24.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Product Detected',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ColorHelper.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              _buildInfoRow('Product Name:', _productName),
                              SizedBox(height: 16.h),
                              _buildInfoRow('Portion Size:', _portionSize),
                              SizedBox(height: 16.h),
                              _buildInfoRow('Barcode:', _barcodeNumber),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: (){},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 12.h,
                                ),
                              ),
                              child: Text(
                                'Scan Again',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            SizedBox(
                              width: 200.w,
                              child: CommonComponents().commonButton(
                                text: "View Analysis",
                                onPressed: _proceedToResults,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
final AuthController authController=Get.find();
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
          'Barcode Scanner',
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
            // Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              width: 200.w,
              child: CommonComponents().commonButton(
                text: "Scan Barcode",
                onPressed: (){},
              ),
            ),

            // Results section
            if (_productName.isNotEmpty)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Product details card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Detected Product:',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _productName,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Portion Size:',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _portionSize,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (_barcodeNumber.isNotEmpty) ...[
                              SizedBox(height: 12.h),
                              Text(
                                'Barcode:',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _barcodeNumber,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Buttons section
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: 200.w,
                        child: ElevatedButton(
                          onPressed: _proceedToResults,
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
                      SizedBox(height: 8.h),
                      TextButton(
                        onPressed: (){},
                        child: Text(
                          'Scan Again',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color:  ColorHelper.primaryColor,
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

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 1024) {
      ScreenUtil.init(
        context,
        designSize: const Size(1440, 900),
        minTextAdapt: true,
        splitScreenMode: true,
      );
      return _buildDesktopView();
    } else {
      ScreenUtil.init(
        context,
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
      );
      return _buildMobileView();
    }
  }
}