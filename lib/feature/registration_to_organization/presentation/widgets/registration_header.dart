import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class RegistrationHeader extends StatelessWidget {
  const RegistrationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Join Organization',
          style: AppTextStyle.font18BoldBlack.copyWith(
            fontSize: 28.sp,
            fontWeight: FontWeightHelper.bold,
          ),
        ),
        verticalSpace(8),

        // Subtitle
        Text(
          'Request access to your school or company',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.subTextColorGrey,
            fontWeight: FontWeightHelper.regular,
          ),
        ),
        verticalSpace(32),
      ],
    );
  }
}

