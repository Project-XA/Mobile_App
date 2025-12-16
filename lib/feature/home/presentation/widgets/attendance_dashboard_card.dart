import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class AttendanceDashboardCard extends StatelessWidget {
  const AttendanceDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backGroundColorWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard Header (Blue Section)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.buttonColorBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeightHelper.regular,
                    color: Colors.blue.shade100,
                  ),
                ),
                verticalSpace(8),
                Text(
                  'Attendance Dashboard',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: Colors.white,
                  ),
                ),
                verticalSpace(8),
                Text(
                  'Check in when session is active',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeightHelper.regular,
                    color: Colors.blue.shade100,
                  ),
                ),
              ],
            ),
          ),

          // Session Status (Green Section)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.statusGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No active session',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.medium,
                    color: AppColors.statusGreenText,
                  ),
                ),
                verticalSpace(8),
                Text(
                  'Wait for your organization to start a session',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeightHelper.regular,
                    color: AppColors.statusGreenTextDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
