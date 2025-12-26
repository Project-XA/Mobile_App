import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class UserNameSection extends StatelessWidget {
  final String fullNameEn;

  const UserNameSection({super.key, required this.fullNameEn});

  @override
  Widget build(BuildContext context) {
    return Text(
      fullNameEn,
      style: AppTextStyle.font14MediamGrey.copyWith(
        color: Colors.white,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class UserEmailSection extends StatelessWidget {
  final String email;

  const UserEmailSection({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Text(
      email,
      style: AppTextStyle.font14MediamGrey.copyWith(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.9),
        fontSize: 14.sp,
      ),
    );
  }
}

class UserRoleSection extends StatelessWidget {
  final String role;

  const UserRoleSection({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        role,
        style: AppTextStyle.font14MediamGrey.copyWith(
          color: Colors.white,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}