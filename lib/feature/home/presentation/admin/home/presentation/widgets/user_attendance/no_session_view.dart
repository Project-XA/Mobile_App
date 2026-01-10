import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class NoSessionView extends StatelessWidget {
  const NoSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_alt,
            size: 64.sp,
            color: Colors.grey.shade400,
          ),
          verticalSpace(16.h),
          Text(
            'User Attendance',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeightHelper.bold,
              color: AppColors.mainTextColorBlack,
            ),
          ),
          verticalSpace(8.h),
          Text(
            'No active session',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
          ),
          verticalSpace(4.h),
          Text(
            'Start a session to view attendance',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
