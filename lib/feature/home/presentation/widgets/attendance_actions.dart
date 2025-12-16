import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';

class AttendanceActions extends StatelessWidget {
  const AttendanceActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          // Take Attendance Button (Green)
          CustomAppButton(
            onPressed: () {
              // Handle take attendance action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No active session available'),
                ),
              );
            },
            backgroundColor: AppColors.buttonColorGreen,
            borderRadius: 12.r,
            child: Text(
              'Take Attendance',
              style: AppTextStyle.font15SemiBoldWhite.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
          ),
          verticalSpace(16),

          // View Profile Button (Blue)
          CustomAppButton(
            onPressed: () {
              context.pushNamed(Routes.profilePage);
            },
            backgroundColor: AppColors.buttonColorBlue,
            borderRadius: 12.r,
            child: Text(
              'View Profile',
              style: AppTextStyle.font15SemiBoldWhite.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
          ),
          verticalSpace(24),
        ],
      ),
    );
  }
}
