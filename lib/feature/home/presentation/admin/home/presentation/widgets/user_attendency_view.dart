import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/user_attendance/attendance_card_widget.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/user_attendance/attendance_stats_header.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/user_attendance/empty_attendance_view.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/user_attendance/no_session_view.dart';

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

        return const NoSessionView();
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
      return EmptyAttendanceView(isActive: isActive);
    }

    return Column(
      children: [
        AttendanceStatsHeader(
          totalCount: attendanceList.length,
          isActive: isActive,
        ),
        
        verticalSpace(16.h),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 16.h),
            itemCount: attendanceList.length,
            itemBuilder: (context, index) {
              final record = attendanceList[index];
              final isLatest = latestRecord != null && 
                              record.userId == latestRecord.userId &&
                              record.checkInTime == latestRecord.checkInTime;
              
              return AttendanceCardWidget(
                record: record,
                number: index + 1,
                isLatest: isLatest,
              );
            },
          ),
        ),
      ],
    );
  }
}