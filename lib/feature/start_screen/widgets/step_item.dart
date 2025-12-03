import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class StepItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const StepItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32.sp, color: AppColors.mainTextColorBlack),
          horizontalSpace(16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.font18BoldBlack),

              verticalSpace(4),

              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.subTextColorGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
