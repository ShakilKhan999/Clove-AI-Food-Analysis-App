import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/auth/views/login_screen.dart';
import 'package:get/get.dart';

import '../../helpers/appbar.dart';
import '../../helpers/color_helper.dart';
import '../../helpers/common_components.dart';
import '../../helpers/space_helper.dart';
import '../controller/auth_controller.dart';
import '../controller/auth_serviece.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final AuthController authController = Get.put(AuthController());

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return Container(
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
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(icon, color: ColorHelper.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        ),
      ),
    );
  }

  Widget _buildDesktopView() {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Row(
        children: [
          // Left Panel - Image/Illustration
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorHelper.primaryColor,
                    Color(0xFF1976D2),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.water_drop,
                    size: 80.sp,
                    color: Colors.white,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Welcome to FoodRecipe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Track and predict your glucose levels\nwith ease',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18.sp,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right Panel - Signup Form
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(48.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Fill in your details to get started',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    _buildTextField(
                      authController.fullNameController,
                      'Full Name',
                      Icons.person_outline,
                    ),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      authController.addressController,
                      'Address',
                      Icons.location_on_outlined,
                    ),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      authController.mobileController,
                      'Mobile Number',
                      Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      authController.emailController,
                      'Email',
                      Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Obx(
                          () => SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: Checkbox(
                              value: authController.agreeToPolicy.value,
                              onChanged: (value) {
                                authController.agreeToPolicy.value = value!;
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.sp,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    color: ColorHelper.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: ColorHelper.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorHelper.primaryColor,
                            Color(0xFF1976D2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: ColorHelper.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Obx(() => authController.isLoading.value
                          ? CircularProgressIndicator()
                          : Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12.r),
                                onTap: () {
                                  authController.signup();
                                },
                                child: Center(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey[300],
                            margin: EdgeInsets.symmetric(horizontal: 24.w),
                          ),
                        ),
                        Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey[300],
                            margin: EdgeInsets.symmetric(horizontal: 24.w),
                          ),
                        ),
                      ],
                    ),
                    Center(child: _buildGoogleSignUpButton()),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: ColorHelper.primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileView() {
    return SafeArea(
      child: Scaffold(
        // appBar: CustomAppBar(
        //   imagePath: 'assets/images/clove.png',
        //   // icon: Icons.restaurant,
        // ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: Column(
              children: [
                SpaceHelper.verticalSpace10,
                Image.asset('assets/images/clove.png',
                    width: 100.w, height: 50.h),
                CommonComponents().printText(
                    fontSize: 20,
                    color: ColorHelper.primaryColor,
                    maxLine: 2,
                    textAlign: TextAlign.center,
                    textData: 'Welcome to Clove, the ultimate food recipe app!',
                    fontWeight: FontWeight.w500),
                SpaceHelper.verticalSpace30,
                CommonComponents().commonTextField(
                    controller: authController.fullNameController,
                    labelColor: Colors.black,
                    labelText: 'FullName'),
                SpaceHelper.verticalSpace10,
                CommonComponents().commonTextField(
                    controller: authController.addressController,
                    labelColor: Colors.black,
                    labelText: 'Address'),
                SpaceHelper.verticalSpace10,
                CommonComponents().commonTextField(
                    controller: authController.mobileController,
                    labelColor: Colors.black,
                    labelText: 'Mobile Number'),
                SpaceHelper.verticalSpace10,
                CommonComponents().commonTextField(
                    controller: authController.emailController,
                    labelColor: Colors.black,
                    labelText: 'Email'),
                SpaceHelper.verticalSpace10,
                CommonComponents().commonTextField(
                    controller: authController.passwordController,
                    labelColor: Colors.black,
                    isPassword: true,
                    labelText: 'Password'),
                SpaceHelper.verticalSpace20,
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: authController.agreeToPolicy.value,
                        onChanged: (value) {
                          authController.agreeToPolicy.value = value!;
                        },
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'I agree to the ',
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                          children: [
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14.sp),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SpaceHelper.verticalSpace10,
                Obx(
                  () => authController.isLoading.value
                      ? CircularProgressIndicator()
                      : CommonComponents().commonButton(
                          text: 'Sign Up',
                          onPressed: () async {
                            await authController.signup();
                          },
                        ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey[300],
                        margin: EdgeInsets.symmetric(horizontal: 24.w),
                      ),
                    ),
                    Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey[300],
                        margin: EdgeInsets.symmetric(horizontal: 24.w),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Center(child: _buildGoogleSignUpButton()),
                SpaceHelper.verticalSpace5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: ColorHelper.primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(LoginScreen());
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: ColorHelper.primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
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

    return isDesktop ? _buildDesktopView() : _buildMobileView();
  }

  Widget _buildGoogleSignUpButton() {
    return Container(
      width: 200.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () async {
            await AuthService().registerWithGoogle();
          },
          child: Obx(
            () => authController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorHelper.primaryColor,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24.h,
                        height: 24.h,
                        child: Image.network(
                          'https://cdn4.iconfinder.com/data/icons/logos-brands-7/512/google_logo-google_icongoogle-512.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Sign up with Google',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
