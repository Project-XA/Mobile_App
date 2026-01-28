import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/features/attendance/presentation/logic/user_cubit.dart';

class NoSessionsCard extends StatelessWidget {
  final bool isIdle;
  final bool isDiscoveryActive;

  const NoSessionsCard({
    super.key,
    required this.isIdle,
    required this.isDiscoveryActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade100, Colors.white],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildIcon(),
          verticalSpace(20.h),
          _buildTitle(),
          verticalSpace(12.h),
          _buildDescription(),
          verticalSpace(18.h),
          _buildActionButton(context),
          if (isDiscoveryActive) ...[
            verticalSpace(16.h),
            _buildInfoBanner(),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isIdle ? Icons.search : Icons.wifi_off_rounded,
        size: 56.sp,
        color: AppColors.mainTextColorBlack,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      isIdle ? 'Ready to Search' : 'No Sessions Found',
      style: AppTextStyle.font14MediamGrey.copyWith(
        fontSize: 22.sp,
        fontWeight: FontWeightHelper.bold,
        color: AppColors.mainTextColorBlack,
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        isIdle
            ? 'Start searching to discover active\nattendance sessions nearby'
            : 'No active sessions were found in your area.\nSessions may have ended or moved.',
        textAlign: TextAlign.center,
        style: AppTextStyle.font14MediamGrey.copyWith(
          fontSize: 14.sp,
          color: Colors.grey.shade600,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return CustomAppButton(
      onPressed: () {
        if (isIdle) {
          context.read<UserCubit>().startSessionDiscovery();
        } else {
          context.read<UserCubit>().refreshSessions();
        }
      },
      backgroundColor: AppColors.mainTextColorBlack,
      borderRadius: 16.r,
      width: 200.w,
      height: 48.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isIdle ? Icons.search : Icons.refresh,
            color: Colors.white,
            size: 20.sp,
          ),
          horizontalSpace(10.w),
          Text(
            isIdle ? 'Start Search' : 'Search Again',
            style: AppTextStyle.font14MediamGrey.copyWith(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeightHelper.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            size: 16.sp,
            color: Colors.orange.shade700,
          ),
          horizontalSpace(8.w),
          Text(
            'Make sure you\'re close to the venue',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 12.sp,
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }
}