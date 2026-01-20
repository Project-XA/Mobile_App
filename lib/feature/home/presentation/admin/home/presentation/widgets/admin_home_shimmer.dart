import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AdminHomeShimmer extends StatelessWidget {
  const AdminHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    return Scaffold(
      backgroundColor: AppColors.backGroundColorWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isSmallScreen),
            verticalSpace(20),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12.w : 20.w,
                vertical: 8.h,
              ),
              child: Column(
                children: [
                  _buildInfoCard(isSmallScreen),
                  verticalSpace(16.h),
                  _buildToggleTabs(isSmallScreen),
                ],
              ),
            ),
            verticalSpace(20.h),
            Expanded(child: _buildContent(isSmallScreen)),
          ],
        ),
      ),
    );
  }

  // ==================== Header ====================
  Widget _buildHeader(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12.w : 16.w,
        vertical: 8.h,
      ),
      child: Row(
        children: [
          // Avatar
          Shimmer(
            duration: const Duration(seconds: 3),
            color: Colors.grey[100]!,
            colorOpacity: 0.3, 
            child: Container(
              width: isSmallScreen ? 45.w : 50.w,
              height: isSmallScreen ? 45.w : 50.w,
              decoration: BoxDecoration(
                color: Colors.grey[100], 
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), 
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: isSmallScreen ? 10.w : 12.w),

          // Name and role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Name
                Shimmer(
                  duration: const Duration(seconds: 3),
                  color: Colors.grey[100]!,
                  colorOpacity: 0.3,
                  child: Container(
                    width: 120.w,
                    height: isSmallScreen ? 14.h : 16.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                verticalSpace(4.h),
                // Role
                Shimmer(
                  duration: const Duration(seconds: 3),
                  color: Colors.grey[100]!,
                  colorOpacity: 0.3,
                  child: Container(
                    width: 60.w,
                    height: isSmallScreen ? 11.h : 14.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ),

          horizontalSpace(8.w),
        ],
      ),
    );
  }

  // ==================== Info Card ====================
  Widget _buildInfoCard(bool isSmallScreen) {
    return Shimmer(
      duration: const Duration(seconds: 3),
      color: Colors.grey[100]!,
      colorOpacity: 0.3,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isSmallScreen ? 16.w : 20.w),
        decoration: BoxDecoration(
          color: Colors.grey[50], 
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              width: 150.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            verticalSpace(8.h),
            // Subtitle
            Container(
              width: 200.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            verticalSpace(8.h),
            // Description
            Container(
              width: 180.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTabs(bool isSmallScreen) {
    return Shimmer(
      duration: const Duration(seconds: 3),
      color: Colors.grey[100]!,
      colorOpacity: 0.3,
      child: Container(
        width: double.infinity,
        height: isSmallScreen ? 45.h : 50.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          children: [
            // Tab 1
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(22.r),
                ),
              ),
            ),
            horizontalSpace(4.w),
            // Tab 2
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(22.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Content (Form Fields) ====================
  Widget _buildContent(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        children: [
          _buildFormFieldShimmer(isSmallScreen, 'Session Name'),
          verticalSpace(16.h),

          _buildFormFieldShimmer(isSmallScreen, 'Location'),
          verticalSpace(16.h),

          _buildSectionLabel(isSmallScreen, 'CONNECTION METHOD'),
          verticalSpace(8.h),
          _buildFormFieldShimmer(isSmallScreen, 'Dropdown'),
          verticalSpace(16.h),

          _buildSectionLabel(isSmallScreen, 'SESSION START TIME'),
          verticalSpace(8.h),
          _buildFormFieldShimmer(isSmallScreen, 'Time Picker'),
          verticalSpace(16.h),

          _buildSectionLabel(isSmallScreen, 'SESSION DURATION (MINUTES)'),
          verticalSpace(8.h),
          _buildFormFieldShimmer(isSmallScreen, 'Number Input'),
          verticalSpace(24.h),

          _buildButtonShimmer(isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(bool isSmallScreen, String label) {
    return Shimmer(
      duration: const Duration(seconds: 3),
      color: Colors.grey[100]!,
      colorOpacity: 0.3,
      child: Container(
        width: 200.w,
        height: isSmallScreen ? 11.h : 12.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  Widget _buildFormFieldShimmer(bool isSmallScreen, String type) {
    return Shimmer(
      duration: const Duration(seconds: 3),
      color: Colors.grey[100]!,
      colorOpacity: 0.3,
      child: Container(
        width: double.infinity,
        height: isSmallScreen ? 50.h : 56.h,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: Colors.grey[200]!, 
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            // Placeholder text
            Expanded(
              child: Container(
                width: 100.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            // Icon (for dropdown/time picker)
            if (type == 'Dropdown' || type == 'Time Picker')
              Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonShimmer(bool isSmallScreen) {
    return Shimmer(
      duration: const Duration(seconds: 3),
      color: Colors.grey[100]!,
      colorOpacity: 0.3,
      child: Container(
        width: double.infinity,
        height: isSmallScreen ? 50.h : 56.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(28.r),
        ),
      ),
    );
  }
}
