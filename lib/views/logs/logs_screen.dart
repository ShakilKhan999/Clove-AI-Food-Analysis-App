import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/helpers/color_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../auth/controller/auth_serviece.dart';
import '../../helpers/appbar.dart';
import 'log_controller.dart';
import 'log_detail.dart';
import 'log_model.dart';

class LogsScreen extends StatefulWidget {
  LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final int shimmerItemCount = 5;

  final LogController logController = Get.put(LogController());
  @override
  void initState() {
    if (logController.allLogs.isEmpty) {
      logController.listenToLogs(AuthService().auth.currentUser!.uid);
    }
    super.initState();
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  Color _getImpactColor(String? impact) {
    if (impact == null) return Colors.grey;
    impact = impact.toLowerCase();
    if (impact.contains('low')) return Colors.green;
    if (impact.contains('moderate')) return Colors.orange;
    if (impact.contains('high')) return Colors.red;
    return Colors.grey;
  }

  Widget _buildMobileView() {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: ColorHelper.primaryColor,
        elevation: 0,
        title: Text(
          'Logs',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (logController.isLoading.value) {
          return ListView.builder(
            padding: EdgeInsets.all(16.sp),
            itemCount: shimmerItemCount,
            itemBuilder: (context, index) => _buildMobileShimmerLogCard(),
          );
        } else if (logController.allLogs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.note_alt_outlined, size: 48.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'No logs found',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(16.sp),
            itemCount: logController.allLogs.length,
            itemBuilder: (context, index) {
              final log = logController.allLogs[index];
              return _buildMobileLogCard(log);
            },
          );
        }
      }),
    );
  }

  Widget _buildMobileLogCard(LogModel log) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogDetailScreen(log: log),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and impact indicator
            Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 18.sp, color: Colors.grey[600]),
                  SizedBox(width: 8.w),
                  Text(
                    _formatDateTime(log.logTime),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: _getImpactColor(log.foodData?.glucoseImpact)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      log.foodData?.glucoseImpact ?? 'N/A',
                      style: TextStyle(
                        color: _getImpactColor(log.foodData?.glucoseImpact),
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Food details
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.foodData?.foodName ?? 'Unknown Food',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (log.foodData?.portionSize != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      log.foodData!.portionSize!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Widget _buildDesktopView() {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32.sp),
        child: Obx(() {
          if (logController.isLoading.value) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDesktopShimmerHeader(),
                SizedBox(height: 24.h),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 24.w,
                    mainAxisSpacing: 24.h,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: shimmerItemCount,
                  itemBuilder: (context, index) =>
                      _buildDesktopShimmerLogCard(),
                ),
              ],
            );
          } else if (logController.allLogs.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDesktopHeader(),
                SizedBox(height: 48.h),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_alt_outlined,
                          size: 64.sp, color: Colors.grey),
                      SizedBox(height: 16.h),
                      Text(
                        'No logs found',
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDesktopHeader(),
                SizedBox(height: 24.h),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 24.w,
                    mainAxisSpacing: 24.h,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: logController.allLogs.length,
                  itemBuilder: (context, index) {
                    final log = logController.allLogs[index];
                    return _buildDesktopLogCard(log);
                  },
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  // Mobile shimmer log card
  Widget _buildMobileShimmerLogCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                _buildShimmerContainer(width: 18.w, height: 18.h),
                SizedBox(width: 8.w),
                _buildShimmerContainer(width: 120.w, height: 14.h),
                Spacer(),
                _buildShimmerContainer(
                  width: 60.w,
                  height: 20.h,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerContainer(width: 200.w, height: 16.h),
                SizedBox(height: 4.h),
                _buildShimmerContainer(width: 150.w, height: 14.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Desktop shimmer log card
  Widget _buildDesktopShimmerLogCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                _buildShimmerContainer(width: 18.w, height: 18.h),
                SizedBox(width: 8.w),
                _buildShimmerContainer(width: 120.w, height: 14.h),
                Spacer(),
                _buildShimmerContainer(
                  width: 80.w,
                  height: 24.h,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerContainer(width: 250.w, height: 16.h),
                SizedBox(height: 4.h),
                _buildShimmerContainer(width: 180.w, height: 14.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Desktop shimmer header
  Widget _buildDesktopShimmerHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerContainer(width: 150.w, height: 24.h),
              SizedBox(height: 8.h),
              _buildShimmerContainer(width: 250.w, height: 16.h),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildShimmerContainer(width: 24.w, height: 24.h),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildShimmerContainer(width: 80.w, height: 14.h),
                    SizedBox(height: 4.h),
                    _buildShimmerContainer(width: 60.w, height: 18.h),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Food Logs',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Track your meals and their glucose impact',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Spacer(),
          _buildStatCard(
            title: 'Total Logs',
            value: logController.allLogs.length.toString(),
            icon: Icons.note_alt_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLogCard(LogModel log) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 18.sp, color: Colors.grey[600]),
                SizedBox(width: 8.w),
                Text(
                  _formatDateTime(log.logTime),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getImpactColor(log.foodData?.glucoseImpact)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    log.foodData?.glucoseImpact ?? 'N/A',
                    style: TextStyle(
                      color: _getImpactColor(log.foodData?.glucoseImpact),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.foodData?.foodName ?? 'Unknown Food',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (log.foodData?.portionSize != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    log.foodData!.portionSize!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
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
}
