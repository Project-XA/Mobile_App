import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class EmptyAttendanceView extends StatelessWidget {
  final bool isActive;

  const EmptyAttendanceView({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? Icons.hourglass_empty : Icons.event_busy,
            size: 64.sp,
            color: Colors.grey.shade400,
          ),
          verticalSpace(16.h),
          Text(
            isActive ? 'Waiting for Attendance' : 'No Attendance Recorded',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeightHelper.bold,
              color: AppColors.mainTextColorBlack,
            ),
          ),
          verticalSpace(8.h),
          Text(
            isActive 
                ? 'Users will appear here when they check in'
                : 'No users checked in during this session',
            textAlign: TextAlign.center,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
