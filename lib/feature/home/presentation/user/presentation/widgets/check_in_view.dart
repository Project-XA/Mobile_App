import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/logic/user_state.dart';

class CheckInView extends StatelessWidget {
  final CheckInState state;

  const CheckInView({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.isLoading) ..._buildLoadingState(),
            if (state.isSuccess) ..._buildSuccessState(),
            if (state.isFailed) ..._buildFailedState(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLoadingState() {
    return [
      const CircularProgressIndicator(),
      verticalSpace(24.h),
      Text(
        'Checking In...',
        style: AppTextStyle.font14MediamGrey.copyWith(
          fontSize: 20.sp,
          fontWeight: FontWeightHelper.semiBold,
        ),
      ),
      verticalSpace(12.h),
      Text(
        'Please wait',
        style: AppTextStyle.font14MediamGrey.copyWith(
          fontSize: 14.sp,
          color: Colors.grey.shade600,
        ),
      ),
    ];
  }

  List<Widget> _buildSuccessState() {
    return [
      Icon(Icons.check_circle, color: Colors.green, size: 100.sp),
      verticalSpace(24.h),
      Text(
        'Check-In Successful!',
        style: AppTextStyle.font14MediamGrey.copyWith(
          fontSize: 24.sp,
          fontWeight: FontWeightHelper.bold,
          color: Colors.green,
        ),
      ),
      verticalSpace(12.h),
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.event,
              'Session',
              state.session.name,
              Colors.green.shade700,
            ),
            verticalSpace(8.h),
            _buildInfoRow(
              Icons.location_on,
              'Location',
              state.session.location,
              Colors.green.shade700,
            ),
            verticalSpace(8.h),
            _buildInfoRow(
              Icons.access_time,
              'Time',
              DateFormat('hh:mm a').format(state.checkInTime!),
              Colors.green.shade700,
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildFailedState() {
    return [
      Icon(Icons.error, color: Colors.red, size: 100.sp),
      verticalSpace(24.h),
      Text(
        'Check-In Failed',
        style: AppTextStyle.font14MediamGrey.copyWith(
          fontSize: 24.sp,
          fontWeight: FontWeightHelper.bold,
          color: Colors.red,
        ),
      ),
      verticalSpace(12.h),
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Text(
          state.errorMessage ?? 'Please try again',
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 14.sp,
            color: Colors.red.shade900,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: iconColor),
        horizontalSpace(8.w),
        Text(
          '$label:',
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 13.sp,
            color: Colors.grey.shade700,
          ),
        ),
        horizontalSpace(8.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeightHelper.medium,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}