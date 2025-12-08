import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.mainTextColorBlack,
            fontWeight: FontWeightHelper.medium,
          ),
        ),
        verticalSpace(8),
        AppTextFormField(
          controller: controller,
          hintText: 'Enter your password',
          obscureText: true,
          borderRadius: 12.r,
          focusedBorderColor: AppColors.buttonColorBlue,
          enabledBorderColor: Colors.grey.shade300,
          backgroundColor: AppColors.backGroundColorWhite,
          textStyle: TextStyle(
            fontSize: 16.sp,
            color: AppColors.mainTextColorBlack,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
        verticalSpace(24),
      ],
    );
  }
}

