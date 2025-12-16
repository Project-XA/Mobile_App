import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Avatar and User Info (Clickable)
          GestureDetector(
            onTap: () {
              context.pushNamed(Routes.profilePage);
            },
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: AppColors.buttonColorBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeightHelper.bold,
                      ),
                    ),
                  ),
                ),
                horizontalSpace(12),
                // Name and Organization
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ahmed Mohammed',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeightHelper.bold,
                        color: AppColors.mainTextColorBlack,
                      ),
                    ),
                    Text(
                      'Sample University',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeightHelper.regular,
                        color: AppColors.buttonColorGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Right: Logout/Back Button
          GestureDetector(
            onTap: () {
              context.pushReplacmentNamed(
                Routes.registrationToOrganization,
              );
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
