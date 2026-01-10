import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';
import 'package:intl/intl.dart';

class UserAttendanceView extends StatelessWidget {
  const UserAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is SessionState && state.isActive) {
          return _buildAttendanceList(
            context,
            state.session.attendanceList,
            isActive: true,
            latestRecord: state.latestRecord,
          );
        }

        if (state is SessionState && 
            state.operation == SessionOperation.ended) {
          return _buildAttendanceList(
            context,
            state.session.attendanceList,
            isActive: false,
          );
        }

        return _buildNoSessionView();
      },
    );
  }

  Widget _buildAttendanceList(
    BuildContext context,
    List<dynamic> attendanceList, {
    required bool isActive,
    dynamic latestRecord,
  }) {
    if (attendanceList.isEmpty) {
      return _buildEmptyAttendanceView(isActive);
    }

    return Column(
      children: [
        // Stats Header
        _buildStatsHeader(attendanceList, isActive),
        
        verticalSpace(16.h),

        // Attendance List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 16.h),
            itemCount: attendanceList.length,
            itemBuilder: (context, index) {
              final record = attendanceList[index];
              final isLatest = latestRecord != null && 
                              record.userId == latestRecord.userId &&
                              record.checkInTime == latestRecord.checkInTime;
              
              return _buildAttendanceCard(
                context,
                record,
                index + 1,
                isLatest,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsHeader(List<dynamic> attendanceList, bool isActive) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isActive ? Icons.people : Icons.check_circle,
                    size: 20.sp,
                    color: isActive ? Colors.green : Colors.blue,
                  ),
                  horizontalSpace(8.w),
                  Text(
                    'Total Attendance',
                    style: AppTextStyle.font14MediamGrey.copyWith(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              verticalSpace(4.h),
              Text(
                '${attendanceList.length}',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: AppColors.mainTextColorBlack,
                ),
              ),
            ],
          ),
          
          if (isActive)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  horizontalSpace(6.w),
                  Text(
                    'Live',
                    style: AppTextStyle.font14MediamGrey.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeightHelper.semiBold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(
    BuildContext context,
    dynamic record,
    int number,
    bool isLatest,
  ) {
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
            // Number Badge
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: isLatest 
                    ? Colors.green 
                    : AppColors.mainTextColorBlack,
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
            ),

            horizontalSpace(12.w),

            // User Info
            Expanded(
              child: Column(
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
              ),
            ),

            // Time
            Column(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAttendanceView(bool isActive) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? Icons.hourglass_empty : Icons.event_busy,
            size: 64.sp,
            color: Colors.grey.shade400,
          ),
          verticalSpace(16.h),
          Text(
            isActive ? 'Waiting for Attendance' : 'No Attendance Recorded',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeightHelper.bold,
              color: AppColors.mainTextColorBlack,
            ),
          ),
          verticalSpace(8.h),
          Text(
            isActive 
                ? 'Users will appear here when they check in'
                : 'No users checked in during this session',
            textAlign: TextAlign.center,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSessionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_alt,
            size: 64.sp,
            color: Colors.grey.shade400,
          ),
          verticalSpace(16.h),
          Text(
            'User Attendance',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeightHelper.bold,
              color: AppColors.mainTextColorBlack,
            ),
          ),
          verticalSpace(8.h),
          Text(
            'No active session',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
          ),
          verticalSpace(4.h),
          Text(
            'Start a session to view attendance',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}