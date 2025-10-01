import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/auth/views/signup_screen.dart';
import 'package:food_recepi/controllers/themeController.dart';
import 'package:get/get.dart';

import '../../helpers/appbar.dart';
import '../../helpers/color_helper.dart';
import '../../helpers/common_components.dart';
import '../../helpers/space_helper.dart';
import '../controller/auth_controller.dart';
import '../controller/auth_serviece.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final AuthController authController = Get.put(AuthController());
  final ThemeController themeController = Get.put(ThemeController());

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText:
            isPassword ? !authController.isPasswordVisible.value : false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(icon, color: ColorHelper.primaryColor),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    authController.isPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: ColorHelper.primaryColor,
                  ),
                  onPressed: () => authController.togglePasswordVisibility(),
                )
              : null,
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
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          // Left Panel - Image/Illustration
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
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
                    'Welcome Back',
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
          // Right Panel - Login Form
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(48.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Welcome back! Please enter your details',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    _buildTextField(
                      authController.emailController,
                      'Email',
                      Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      authController.passwordController,
                      'Password',
                      Icons.lock_outline,
                      isPassword: true,
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: ColorHelper.primaryColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
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
                            offset: const Offset(0, 2),
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
                                  authController.login();
                                },
                                child: Center(
                                  child: Text(
                                    'Login',
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
                        Container(
                          width: 80.w,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          width: 80.w,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Center(child: _buildGoogleSignInButton()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.offAll(SignupScreen());
                          },
                          child: Text(
                            'Sign Up',
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
        // appBar:  CustomAppBar(
        //   icon: Icons.restaurant,
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
                SpaceHelper.verticalSpace10,
                Image.asset('assets/images/clove.png',
                    width: 100.w, height: 50.h),
                SpaceHelper.verticalSpace10,
                CommonComponents().printText(
                    fontSize: 15,
                    color: Colors.black,
                    maxLine: 2,
                    textAlign: TextAlign.center,
                    textData: 'Welcome back!\nPlease enter your details',
                    fontWeight: FontWeight.w500),
                SpaceHelper.verticalSpace20,
                CommonComponents().commonTextField(
                    controller: authController.emailController,
                    textColor: Colors.black,
                    labelColor: Colors.black,
                    labelText: 'Email'),
                SpaceHelper.verticalSpace10,
                Obx(() => CommonComponents().commonTextField(
                    controller: authController.passwordController,
                    labelColor: Colors.black,
                    textColor: Colors.black,
                    labelText: 'Password',
                    isPassword: true,
                    isPasswordVisible: authController.isPasswordVisible.value,
                    onPasswordVisibilityChanged:
                        authController.togglePasswordVisibility)),
                SpaceHelper.verticalSpace10,
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: ColorHelper.primaryColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SpaceHelper.verticalSpace10,
                Obx(() => authController.isLoading.value
                    ? CircularProgressIndicator()
                    : CommonComponents().commonButton(
                        text: 'Login',
                        onPressed: () {
                          authController.login();
                        },
                      )),
                SpaceHelper.verticalSpace10,
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                _buildGoogleSignInButton(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(SignupScreen());
                      },
                      child: Text(
                        'Sign Up',
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

  Widget _buildGoogleSignInButton() {
    return Container(
      width: kIsWeb ? 200.w : double.infinity,
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
          onTap: () => AuthService().loginWithGoogle(),
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
                        'Continue with Google',
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
