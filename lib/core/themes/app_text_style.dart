import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class AppTextStyle {
  // use it in text inside button
  static TextStyle font15SemiBoldWhite = TextStyle(
    color: AppColors.backGroundColorWhite,
    fontWeight: FontWeightHelper.semiBold,
    fontSize: 15.sp,
  );

  // use it in title of screen
  static TextStyle font18BoldBlack = TextStyle(
    color: AppColors.mainTextColorBlack,
    fontWeight: FontWeightHelper.bold,
    fontSize: 18.sp,
  );

  static TextStyle font14MediamGrey = TextStyle(
    fontSize: 14.sp,
    color: Colors.grey.shade600,
    fontWeight: FontWeightHelper.medium,
  );
}
