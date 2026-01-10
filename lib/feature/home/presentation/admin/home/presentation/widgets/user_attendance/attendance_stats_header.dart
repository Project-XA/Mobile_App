import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class AttendanceStatsHeader extends StatelessWidget {
  final int totalCount;
  final bool isActive;

  const AttendanceStatsHeader({
    super.key,
    required this.totalCount,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isActive ? Icons.people : Icons.check_circle,
                    size: 20.sp,
                    color: isActive ? Colors.green : Colors.blue,
                  ),
                  horizontalSpace(8.w),
                  Text(
                    'Total Attendance',
                    style: AppTextStyle.font14MediamGrey.copyWith(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              verticalSpace(4.h),
              Text(
                '$totalCount',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: AppColors.mainTextColorBlack,
                ),
              ),
            ],
          ),
          
          if (isActive)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  horizontalSpace(6.w),
                  Text(
                    'Live',
                    style: AppTextStyle.font14MediamGrey.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeightHelper.semiBold,
                      color: Colors.green.shade700,
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
