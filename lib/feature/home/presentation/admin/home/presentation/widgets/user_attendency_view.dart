import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/attendance_list_widget.dart';

class UserAttendanceView extends StatelessWidget {
  const UserAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        // If there's an active session, show its attendance
        if (state is SessionState && state.isActive) {
          return AttendanceListWidget(
            attendanceList: state.session.attendanceList,
            emptyMessage: 'Waiting for attendance...',
            showStats: true,
          );
        }

        if (state is SessionState && 
            state.operation == SessionOperation.ended) {
          return AttendanceListWidget(
            attendanceList: state.session.attendanceList,
            emptyMessage: 'No attendance recorded',
            showStats: true,
          );
        }

        return _buildNoSessionView();
      },
    );
  }

  Widget _buildNoSessionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_alt,
            size: 80.sp,
            // ignore: deprecated_member_use
            color: Colors.green.withOpacity(0.5),
          ),
          verticalSpace(16.h),
          Text(
            'User Attendance',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          verticalSpace(8.h),
          Text(
            'No active session',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          verticalSpace(4.h),
          Text(
            'Start a session to view attendance',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}