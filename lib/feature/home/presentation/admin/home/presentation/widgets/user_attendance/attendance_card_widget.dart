import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class AttendanceCardWidget extends StatelessWidget {
  final dynamic record;
  final int number;
  final bool isLatest;

  const AttendanceCardWidget({
    super.key,
    required this.record,
    required this.number,
    required this.isLatest,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isLatest ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isLatest ? Colors.green.shade300 : Colors.grey.shade200,
          width: isLatest ? 2 : 1,
        ),
        boxShadow: [
          if (isLatest)
            BoxShadow(
              color: Colors.green.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            _buildNumberBadge(),
            horizontalSpace(12.w),
            Expanded(child: _buildUserInfo()),
            _buildTimeInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberBadge() {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: isLatest ? Colors.green : AppColors.mainTextColorBlack,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                record.userName,
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeightHelper.semiBold,
                  color: AppColors.mainTextColorBlack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isLatest)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'NEW',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        verticalSpace(4.h),
        Row(
          children: [
            Icon(
              Icons.badge,
              size: 12.sp,
              color: Colors.grey.shade600,
            ),
            horizontalSpace(4.w),
            Text(
              'ID: ${record.userId}',
              style: AppTextStyle.font14MediamGrey.copyWith(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        if (record.location != null) ...[
          verticalSpace(4.h),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 12.sp,
                color: Colors.grey.shade600,
              ),
              horizontalSpace(4.w),
              Expanded(
                child: Text(
                  record.location!,
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTimeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(
          Icons.access_time,
          size: 16.sp,
          color: Colors.grey.shade600,
        ),
        verticalSpace(4.h),
        Text(
          DateFormat('HH:mm').format(record.checkInTime),
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.semiBold,
            color: AppColors.mainTextColorBlack,
          ),
        ),
        Text(
          DateFormat('MMM dd').format(record.checkInTime),
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 11.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
