import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/controllers/themeController.dart';
import 'package:food_recepi/helpers/color_helper.dart';
import 'package:food_recepi/views/name_dialogue.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/controller/auth_controller.dart';
import '../auth/controller/auth_serviece.dart';
import '../onboarding/views/onboarding_one_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedActivityLevel;

  final TextEditingController _controller = TextEditingController();
  ThemeController themeController = Get.put(ThemeController());
  SharedPreferences? _prefs;
  static const String _appNameKey = 'app_name';
  double stressLevel = 50;
  double sleepQuality = 50;
  final AuthController authController = Get.find();

  // Modern Mobile View
  Widget _buildMobileView() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            floating: false,
            pinned: true,
            backgroundColor: ColorHelper.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "${authController.userInfo.isEmpty ? "" : authController.userInfo[0]["fullName"]}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorHelper.primaryColor,
                      ColorHelper.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 40.sp,
                          color: ColorHelper.primaryColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Personal Information',
                    [
                      Obx(() => Column(
                            children: [
                              _buildModernTextField(
                                'Name',
                                '${authController.userInfo.isEmpty ? "" : authController.userInfo[0]["fullName"]}',
                                Icons.person_outline,
                              ),
                              _buildModernTextField(
                                'Email',
                                '${authController.userInfo.isEmpty ? "" : authController.userInfo[0]["email"]}',
                                Icons.email_outlined,
                              ),
                            ],
                          )),
                      _buildModernTextField(
                          'Age', '30', Icons.calendar_today_outlined),
                      Row(
                        children: [
                          Expanded(
                            child: _buildModernTextField('Weight (kg)', '70',
                                Icons.monitor_weight_outlined),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildModernTextField(
                                'Height (cm)', '175', Icons.height_outlined),
                          ),
                        ],
                      ),
                      _buildModernTextField(
                        'Blood Glucose',
                        '5 mmol/L',
                        Icons.bloodtype_outlined,
                      ),
                    ],
                  ),
                  _buildSection(
                    'Activity & Wellness',
                    [
                      _buildModernActivityLevel(),
                      _buildModernSlider(
                        'Stress Level',
                        stressLevel,
                        Icons.sentiment_satisfied_outlined,
                        (value) => setState(() => stressLevel = value),
                      ),
                      _buildModernSlider(
                        'Sleep Quality',
                        sleepQuality,
                        Icons.bedtime_outlined,
                        (value) => setState(() => sleepQuality = value),
                      ),
                    ],
                  ),
                  _buildSection(
                    'Subscription',
                    [
                      _buildInfoCard(
                        'Current Plan: Premium',
                        'Unlock all premium features',
                        Icons.star_outline,
                      ),
                      SizedBox(height: 16.h),
                      _buildModernButton(
                        'Upgrade Plan',
                        icon: Icons.upgrade_outlined,
                        gradient: true,
                      ),
                    ],
                  ),
                  _buildSection(
                    'Account',
                    [
                      _buildModernButton(
                        'Log Out',
                        icon: Icons.logout_outlined,
                        onPressed: () async {
                          authController.mealName.value = "";
                          authController.mealList.clear();
                          authController.userInfo.clear();
                          await AuthService().logout();
                          Get.offAll(OnboardingOneScreen());
                        },
                      ),
                      SizedBox(height: 12.h),
                      _buildModernButton(
                        'Delete Account',
                        icon: Icons.delete_outline,
                        color: Colors.red,
                        onPressed: () async {
                          authController.mealName.value = "";
                          authController.mealList.clear();
                          await AuthService().auth.currentUser!.delete();
                          Get.offAll(OnboardingOneScreen());
                        },
                      ),
                      SizedBox(height: 12.h),
                      _buildModernButton(
                        'Change Name',
                        icon: Icons.touch_app_outlined,
                        color: Colors.green,
                        onPressed: () async {
                          showAppNameDialog(context);
                        },
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

  // Modern Desktop View
  Widget _buildDesktopView() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1200.w),
            padding: EdgeInsets.all(32.sp),
            child: Column(
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorHelper.primaryColor,
                        ColorHelper.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: ColorHelper.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(32.sp),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 50.sp,
                          color: ColorHelper.primaryColor,
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile Settings',
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Manage your account preferences and personal information',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),

                // Main Content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Main Information
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildDesktopCard(
                            'Personal Information',
                            Column(
                              children: [
                                Obx(() => Column(
                                      children: [
                                        _buildModernTextField(
                                          'Name',
                                          '${authController.userInfo.isEmpty ? "" : authController.userInfo[0]["fullName"]}',
                                          Icons.person_outline,
                                        ),
                                        _buildModernTextField(
                                          'Email',
                                          '${authController.userInfo.isEmpty ? "" : authController.userInfo[0]["email"]}',
                                          Icons.email_outlined,
                                        ),
                                      ],
                                    )),
                                _buildModernTextField(
                                    'Age', '30', Icons.calendar_today_outlined),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                          'Weight (kg)',
                                          '70',
                                          Icons.monitor_weight_outlined),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: _buildModernTextField(
                                          'Height (cm)',
                                          '175',
                                          Icons.height_outlined),
                                    ),
                                  ],
                                ),
                                _buildModernTextField(
                                  'Blood Glucose',
                                  '5 mmol/L',
                                  Icons.bloodtype_outlined,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          _buildDesktopCard(
                            'Activity & Wellness',
                            Column(
                              children: [
                                _buildModernActivityLevel(),
                                _buildModernSlider(
                                  'Stress Level',
                                  stressLevel,
                                  Icons.sentiment_satisfied_outlined,
                                  (value) =>
                                      setState(() => stressLevel = value),
                                ),
                                _buildModernSlider(
                                  'Sleep Quality',
                                  sleepQuality,
                                  Icons.bedtime_outlined,
                                  (value) =>
                                      setState(() => sleepQuality = value),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 24.w),
                    // Right Column - Additional Information
                    Expanded(
                      child: Column(
                        children: [
                          _buildDesktopCard(
                            'Subscription',
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoCard(
                                  'Premium Plan',
                                  'Access all premium features',
                                  Icons.star_outline,
                                ),
                                SizedBox(height: 16.h),
                                _buildModernButton(
                                  'Upgrade Plan',
                                  icon: Icons.upgrade_outlined,
                                  gradient: true,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          _buildDesktopCard(
                            'Account Management',
                            Column(
                              children: [
                                _buildModernButton(
                                  'Log Out',
                                  icon: Icons.logout_outlined,
                                  onPressed: () async {
                                    authController.mealName.value = "";
                                    authController.mealList.clear();
                                    await AuthService().logout();
                                    Get.offAll(OnboardingOneScreen());
                                  },
                                ),
                                SizedBox(height: 12.h),
                                _buildModernButton(
                                  'Delete Account',
                                  icon: Icons.delete_outline,
                                  color: Colors.red,
                                  onPressed: () async {
                                    authController.mealName.value = "";
                                    authController.mealList.clear();
                                    await AuthService()
                                        .auth
                                        .currentUser!
                                        .delete();
                                    Get.offAll(OnboardingOneScreen());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
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

  // Shared Modern Components
  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDesktopCard(String title, Widget content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 24.h),
          content,
        ],
      ),
    );
  }

  Widget _buildModernTextField(
      String label, String initialValue, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: ColorHelper.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: ColorHelper.primaryColor),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: EdgeInsets.all(16.sp),
        ),
      ),
    );
  }

  Widget _buildModernActivityLevel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Level',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              _buildActivityOption('Sedentary', 'Little to no exercise'),
              Divider(height: 1),
              _buildActivityOption('Lightly Active', '1-3 days/week'),
              Divider(height: 1),
              _buildActivityOption('Moderately Active', '3-5 days/week'),
              Divider(height: 1),
              _buildActivityOption('Very Active', '6-7 days/week'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityOption(String label, String description) {
    final isSelected = selectedActivityLevel == label;

    return InkWell(
      onTap: () => setState(() => selectedActivityLevel = label),
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorHelper.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: label,
              groupValue: selectedActivityLevel,
              onChanged: (value) =>
                  setState(() => selectedActivityLevel = value),
              activeColor: ColorHelper.primaryColor,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSlider(
    String label,
    double value,
    IconData icon,
    Function(double) onChanged,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ColorHelper.primaryColor),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text('Low', style: TextStyle(color: Colors.grey[600])),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 6.h,
                    activeTrackColor: ColorHelper.primaryColor,
                    inactiveTrackColor: Colors.grey[200],
                    thumbColor: Colors.white,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 12.r,
                      elevation: 4,
                    ),
                    overlayColor: ColorHelper.primaryColor.withOpacity(0.2),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 24.r),
                  ),
                  child: Slider(
                    value: value,
                    min: 0,
                    max: 100,
                    onChanged: onChanged,
                  ),
                ),
              ),
              Text('High', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: ColorHelper.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: ColorHelper.primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernButton(
    String text, {
    IconData? icon,
    Color? color,
    bool gradient = false,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: gradient
            ? LinearGradient(
                colors: [
                  ColorHelper.primaryColor,
                  ColorHelper.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: gradient ? null : (color ?? ColorHelper.primaryColor),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: (color ?? ColorHelper.primaryColor).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
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

  Future<void> _loadSavedName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_appNameKey);
    if (savedName != null) {
      setState(() {
        _controller.text = savedName;
      });
    }
  }

  Future<void> _saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appNameKey, name);
  }

  void showAppNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'App Configuration',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set or update your application name.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'App Name',
                  hintText: themeController.appName.value,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_controller.text.trim().isNotEmpty) {
                  await _saveName(_controller.text.trim());
                  themeController.loadSavedName();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
