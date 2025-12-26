// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/services/toast_service.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/models/server_info.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';

class ActiveSessionView extends StatelessWidget {
  final Session session;
  final ServerInfo serverInfo;

  const ActiveSessionView({
    super.key,
    required this.session,
    required this.serverInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSessionInfoCard()),
          SliverToBoxAdapter(child: _buildServerInfoCard(context)),
          SliverToBoxAdapter(child: verticalSpace(20)),
          SliverToBoxAdapter(child: _buildEndSessionButton(context)),
        ],
      ),
    );
  }

  Widget _buildSessionInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
              horizontalSpace(8.w),
              Text(
                'Session Active',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          verticalSpace(12.h),
          _buildInfoRow('Session Name:', session.name),
          verticalSpace(8.h),
          _buildInfoRow('Location:', session.location),
          verticalSpace(8.h),
          _buildInfoRow('Connection:', session.connectionMethod),
          verticalSpace(8.h),
          _buildInfoRow(
            'Start Time:',
            DateFormat('hh:mm a').format(session.startTime),
          ),
          verticalSpace(8.h),
          _buildInfoRow('Duration:', '${session.durationMinutes} minutes'),
        ],
      ),
    );
  }

  Widget _buildServerInfoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.router, color: Colors.blue, size: 20.sp),
              horizontalSpace(8.w),
              Text(
                'Server Information',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeightHelper.semiBold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          verticalSpace(12.h),
          _buildCopyableInfoRow(context, 'IP Address:', serverInfo.ipAddress),
          verticalSpace(8.h),
          _buildInfoRow('Port:', serverInfo.port.toString()),
          verticalSpace(8.h),
          _buildCopyableInfoRow(context, 'mDNS:', 'attendance.local'),
        ],
      ),
    );
  }

  Widget _buildEndSessionButton(BuildContext context) {
    return CustomAppButton(
      onPressed: () => _showEndSessionDialog(context),
      backgroundColor: AppColors.mainTextColorBlack,
      borderRadius: 20.r,
      width: double.infinity,
      height: 45.h,
      child: Text(
        'End Session',
        style: AppTextStyle.font14MediamGrey.copyWith(
          color: Colors.white,
          fontWeight: FontWeightHelper.medium,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  void _showEndSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('End Session'),
        content: Text(
          'Are you sure you want to end this session? '
          '${session.attendanceList.length} attendees have checked in.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.mainTextColorBlack),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AdminCubit>().endSession();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110.w,
          child: Text(
            label,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeightHelper.medium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyableInfoRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110.w,
          child: Text(
            label,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeightHelper.medium,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            showToast(message: 'Copied: $value',type: ToastType.success);
          },
          child: Icon(Icons.copy, size: 16.sp, color: Colors.blue),
        ),
      ],
    );
  }
}
