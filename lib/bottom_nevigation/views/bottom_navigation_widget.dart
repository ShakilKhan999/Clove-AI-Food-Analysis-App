
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth/controller/auth_controller.dart';
import '../../helpers/color_helper.dart';
import '../../views/home_screen.dart';
import '../../views/logs/logs_screen.dart';
import '../../views/profile_screen.dart';
import '../controller/bottom_controller.dart';

class MainLayout extends StatelessWidget {
  MainLayout({super.key});
  final BottomNavigationController appController = Get.find();
  AuthController authController=Get.put(AuthController());

  List<NavigationItem> get navigationItems => [
    NavigationItem(
      index: 0,
      title: 'Home',
      icon: Icons.home,
      iconOutline: Icons.home_outlined,
      screen: HomeScreen(),
    ),
    NavigationItem(
      index: 1,
      title: 'Logs',
      icon: Icons.bookmark,
      iconOutline: Icons.bookmark_outlined,
      screen:  LogsScreen(),
    ),
    NavigationItem(
      index: 2,
      title: 'Profile',
      icon: Icons.person,
      iconOutline: Icons.person_outline,
      screen: const ProfileScreen(),
    ),
  ];

  Widget _buildDrawerItem(NavigationItem item) {
    return Obx(() {
      final isSelected = appController.selectedIndex.value == item.index;
      return ListTile(
        leading: Icon(
          isSelected ? item.icon : item.iconOutline,
          color: isSelected ? ColorHelper.primaryColor : ColorHelper.greyColor,
          size: 24.sp,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: isSelected ? ColorHelper.primaryColor : ColorHelper.greyColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 16.sp,
          ),
        ),
        selected: isSelected,
        selectedTileColor: ColorHelper.primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        onTap: () {
          appController.selectedIndex.value = item.index;
          Navigator.of(Get.context!).pop(); // Close drawer
        },
      );
    });
  }

  Widget _buildBottomNavItem(NavigationItem item) {
    return Obx(() {
      final isSelected = appController.selectedIndex.value == item.index;
      return InkWell(
        onTap: () {
          appController.selectedIndex.value = item.index;
        },
        child: SizedBox(
          width: 33.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? item.icon : item.iconOutline,
                size: 14.sp,
                color: isSelected ? ColorHelper.primaryColor : ColorHelper.greyColor,
              ),
              SizedBox(height: 5.h),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isSelected ? ColorHelper.primaryColor : ColorHelper.greyColor,
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBottomNavBar() {
    return Obx(
          () => Padding(
        padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: ColorHelper.whiteColor.withOpacity(0.4),
          ),
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navigationItems.map((item) => _buildBottomNavItem(item)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 1,
      child: Column(
        children: [
          DrawerHeader(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.water_drop,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'FoodRecipe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              children: navigationItems.map((item) => _buildDrawerItem(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: kIsWeb
          ? const Size(1440, 900)
          : const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Scaffold(
      drawer: kIsWeb ? _buildDrawer() : null,
      appBar: kIsWeb
          ? AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          navigationItems[appController.selectedIndex.value].title,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20.sp,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      )
          : null,
      body: Obx(() => navigationItems[appController.selectedIndex.value].screen),
      bottomNavigationBar: kIsWeb ? null : _buildBottomNavBar(),
    );
  }
}

class NavigationItem {
  final int index;
  final String title;
  final IconData icon;
  final IconData iconOutline;
  final Widget screen;

  NavigationItem({
    required this.index,
    required this.title,
    required this.icon,
    required this.iconOutline,
    required this.screen,
  });
}