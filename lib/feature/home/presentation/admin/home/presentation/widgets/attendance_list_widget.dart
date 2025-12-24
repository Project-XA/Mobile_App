import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/attendency_record.dart';

class AttendanceListWidget extends StatelessWidget {
  final List<AttendanceRecord> attendanceList;
  final String? emptyMessage;
  final bool showStats;

  const AttendanceListWidget({
    super.key,
    required this.attendanceList,
    this.emptyMessage,
    this.showStats = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (showStats) ...[
          SliverToBoxAdapter(child: verticalSpace(20.h)),
          SliverToBoxAdapter(child: _buildAttendanceStats()),
          SliverToBoxAdapter(child: verticalSpace(20.h)),
        ],
        _buildAttendanceSliver(),
        SliverToBoxAdapter(child: verticalSpace(20.h)),
      ],
    );
  }

  Widget _buildAttendanceStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mainTextColorBlack,
            // ignore: deprecated_member_use
            AppColors.mainTextColorBlack.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total Attendance',
            attendanceList.length.toString(),
            Icons.check_circle_outline,
          ),
          Container(
            width: 1,
            height: 40.h,
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem(
            'Unique Users',
            _getUniqueUsersCount().toString(),
            Icons.people,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28.sp),
        verticalSpace(8.h),
        Text(
          value,
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeightHelper.bold,
            color: Colors.white,
          ),
        ),
        verticalSpace(4.h),
        Text(
          label,
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 12.sp,
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceSliver() {
    if (attendanceList.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pending_actions,
                size: 64.sp,
                color: Colors.grey.shade400,
              ),
              verticalSpace(16.h),
              Text(
                emptyMessage ?? 'No attendance records yet',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 16.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final record = attendanceList[index];
            return Column(
              children: [
                _buildAttendanceItem(record, index + 1),
                if (index < attendanceList.length - 1)
                  Divider(height: 1.h, color: Colors.grey.shade300),
              ],
            );
          },
          childCount: attendanceList.length,
        ),
      ),
    );
  }

  Widget _buildAttendanceItem(AttendanceRecord record, int number) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          // Number badge
          Container(
            width: 32.w,
            height: 32.h,
            decoration: const BoxDecoration(
              color: AppColors.mainTextColorBlack,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeightHelper.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          horizontalSpace(12.w),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.userName,
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeightHelper.semiBold,
                  ),
                ),
                verticalSpace(4.h),
                Text(
                  'ID: ${record.userId}',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Time and location
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('hh:mm a').format(record.checkInTime),
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeightHelper.medium,
                ),
              ),
              if (record.location != null) ...[
                verticalSpace(4.h),
                Text(
                  record.location!,
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  int _getUniqueUsersCount() {
    final uniqueUserIds = attendanceList.map((r) => r.userId).toSet();
    return uniqueUserIds.length;
  }
}