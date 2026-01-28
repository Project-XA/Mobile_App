import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/features/attendance/presentation/logic/user_state.dart';

class CheckInView extends StatelessWidget {
  final CheckInState state;

  const CheckInView({super.key, required this.state});

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
      Icon(_getErrorIcon(), color: _getErrorColor(), size: 100.sp),
      verticalSpace(24.h),
      Text(
        _getErrorTitle(),
        style: AppTextStyle.font14MediamGrey.copyWith(
          fontSize: 24.sp,
          fontWeight: FontWeightHelper.bold,
          color: _getErrorColor(),
        ),
      ),
      verticalSpace(12.h),
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: _getErrorColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: _getErrorColor().withOpacity(0.3)),
        ),
        child: Text(
          state.errorMessage ?? 'Please try again',
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 14.sp,
            color: _getErrorColor(),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  IconData _getErrorIcon() {
    final message = state.errorMessage?.toLowerCase() ?? '';
    if (message.contains('already')) return Icons.info;
    if (message.contains('zone') || message.contains('outside')) {
      return Icons.location_off;
    }
    return Icons.error;
  }

  Color _getErrorColor() {
    final message = state.errorMessage?.toLowerCase() ?? '';
    if (message.contains('already')) return Colors.orange;
    if (message.contains('zone') || message.contains('outside')) {
      return Colors.blue;
    }
    return Colors.red;
  }

  String _getErrorTitle() {
    final message = state.errorMessage?.toLowerCase() ?? '';
    if (message.contains('already')) return 'Already Checked In';
    if (message.contains('zone') || message.contains('outside')) {
      return 'Out of Zone';
    }
    return 'Check-In Failed';
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
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
