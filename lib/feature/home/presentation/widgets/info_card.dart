import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final Color backgroundColor;
  final Color textColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    this.backgroundColor = AppColors.mainTextColorBlack,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16.w : 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              color: textColor.withOpacity(0.9),
              fontSize: isSmallScreen ? 11.sp : 12.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),

          verticalSpace(8.h),

          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              color: textColor,
              fontSize: isSmallScreen ? 18.sp : 20.sp,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),

          verticalSpace(6.h),

          // Description
          Text(
            description,
            style: TextStyle(
              color: textColor.withOpacity(0.85),
              fontSize: isSmallScreen ? 12.sp : 13.sp,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
