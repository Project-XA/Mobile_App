import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add_rounded,
              size: 50.sp,
              color: Colors.white,
            ),
          ),

          verticalSpace(15.h),
          Text(
            'Create Account',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeightHelper.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),

          verticalSpace(10.h),

          Text(
            'Sign up to get started with us',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeightHelper.regular,
              color: Colors.white.withOpacity(0.85),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
