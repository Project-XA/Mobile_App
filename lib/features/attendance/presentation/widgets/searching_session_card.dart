import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class SearchingSessionsCard extends StatelessWidget {
  final int searchSecondsRemaining;
  final int totalSearchDuration;

  const SearchingSessionsCard({
    super.key,
    required this.searchSecondsRemaining,
    required this.totalSearchDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // ignore: deprecated_member_use
            AppColors.mainTextColorBlack.withOpacity(0.05),
            // ignore: deprecated_member_use
            AppColors.mainTextColorBlack.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          // ignore: deprecated_member_use
          color: AppColors.mainTextColorBlack.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          verticalSpace(24.h),
          _buildProgressIndicator(),
          verticalSpace(20.h),
          _buildTitle(),
          verticalSpace(8.h),
          _buildDescription(),
          verticalSpace(8.h),
          _buildTimeoutText(),
          verticalSpace(16.h),
          _buildStatusIndicators(),
          verticalSpace(20.h),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60.w,
          height: 60.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            value: searchSecondsRemaining / totalSearchDuration,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.mainTextColorBlack,
            ),
            backgroundColor: Colors.grey.shade200,
          ),
        ),
        Text(
          '$searchSecondsRemaining',
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeightHelper.bold,
            color: AppColors.mainTextColorBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      'Searching for Sessions',
      style: AppTextStyle.font14MediamGrey.copyWith(
        fontSize: 20.sp,
        fontWeight: FontWeightHelper.bold,
        color: AppColors.mainTextColorBlack,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Scanning nearby locations for\nactive attendance sessions',
      textAlign: TextAlign.center,
      style: AppTextStyle.font14MediamGrey.copyWith(
        fontSize: 14.sp,
        color: Colors.grey.shade600,
        height: 1.5,
      ),
    );
  }

  Widget _buildTimeoutText() {
    return Text(
      'Timeout in ${searchSecondsRemaining}s',
      style: AppTextStyle.font14MediamGrey.copyWith(
        fontSize: 12.sp,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _buildStatusIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatusDot(true),
        horizontalSpace(8.w),
        _buildStatusDot(true),
        horizontalSpace(8.w),
        _buildStatusDot(false),
      ],
    );
  }

  Widget _buildStatusDot(bool isActive) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.mainTextColorBlack : Colors.grey.shade300,
      ),
    );
  }
}
