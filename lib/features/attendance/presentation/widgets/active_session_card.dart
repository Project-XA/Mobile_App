import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/curren_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/services/location/location_helper.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/attendance/presentation/logic/user_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

class ActiveSessionCard extends StatelessWidget {
  final NearbySession session;

  const ActiveSessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mainTextColorBlack,
            AppColors.mainTextColorBlack.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          verticalSpace(16.h),
          _buildSessionInfo(),
          verticalSpace(16.h),
          _buildCheckInButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.wifi, color: Colors.white, size: 24.sp),
        ),
        horizontalSpace(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Session Nearby',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: Colors.white,
                ),
              ),
              verticalSpace(4.h),
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 8.sp),
                  horizontalSpace(6.w),
                  Text(
                    'Live Now',
                    style: AppTextStyle.font14MediamGrey.copyWith(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSessionInfo() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.event_note, 'Session:', session.name),
          verticalSpace(8.h),
          _buildInfoRow(Icons.location_on, 'Location:', session.location),
          verticalSpace(8.h),
          _buildInfoRow(
            Icons.access_time,
            'Time:',
            '${DateFormat('hh:mm a').format(session.startTime)} - ${DateFormat('hh:mm a').format(session.endTime)}',
          ),
          verticalSpace(8.h),
          _buildInfoRow(
            Icons.people,
            'Attendees:',
            '${session.attendeeCount} Students',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 16.sp),
        horizontalSpace(8.w),
        Text(
          label,
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        horizontalSpace(8.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeightHelper.medium,
              color: Colors.white,
            ),
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckInButton(BuildContext context) {
    return CustomAppButton(
      onPressed: () => _handleCheckIn(context),
      backgroundColor: Colors.white,
      borderRadius: 20.r,
      width: double.infinity,
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.mainTextColorBlack,
            size: 20.sp,
          ),
          horizontalSpace(8.w),
          Text(
            'Check In Now',
            style: AppTextStyle.font14MediamGrey.copyWith(
              color: AppColors.mainTextColorBlack,
              fontWeight: FontWeightHelper.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckIn(BuildContext context) async {
    final locationStatus = await LocationHelper.check();

    if (locationStatus == LocationStatus.serviceDisabled) {
      // ignore: use_build_context_synchronously
      _showLocationSettingsDialog(context);
      return;
    }

    if (locationStatus == LocationStatus.deniedForever) {
      // ignore: use_build_context_synchronously
      _showAppSettingsDialog(context);
      return;
    }

    // ignore: use_build_context_synchronously
    final user = context.read<CurrentUserCubit>().currentUser;
    if (user != null) {
      // ignore: use_build_context_synchronously
      context.read<UserCubit>().checkIn(
            session,
            userId: user.nationalId,
            userName: user.fullNameEn,
          );
    }
  }

  void _showLocationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backGroundColorWhite,
        title: const Text(
          'Location Services Disabled',
          style: TextStyle(
            color: AppColors.mainTextColorBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Location services are required for check-in. Please enable location services in your device settings.',
          style: TextStyle(color: AppColors.subTextColorGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.subTextColorGrey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainTextColorBlack,
              foregroundColor: AppColors.backGroundColorWhite,
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showAppSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backGroundColorWhite,
        title: const Text(
          'Location Permission Required',
          style: TextStyle(
            color: AppColors.mainTextColorBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Location permission is permanently denied. Please enable it in app settings to check in.',
          style: TextStyle(color: AppColors.subTextColorGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.subTextColorGrey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainTextColorBlack,
              foregroundColor: AppColors.backGroundColorWhite,
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}