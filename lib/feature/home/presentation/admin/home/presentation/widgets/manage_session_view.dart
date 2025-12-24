import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/create_session_form.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/active_session_view.dart';

class ManageSessionsView extends StatelessWidget {
  const ManageSessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is SessionState && state.isActive) {
          return ActiveSessionView(
            session: state.session,
            serverInfo: state.serverInfo!,
          );
        }

        // Session operations in progress
        if (state is SessionState && state.isLoading) {
          return _buildLoadingView(state.operation);
        }

        // Session ended successfully
        if (state is SessionState && 
            state.operation == SessionOperation.ended) {
          return _buildSessionEndedView(state);
        }

        // Default: Show create session form
        return const SingleChildScrollView(
          child: CreateSessionForm(),
        );
      },
    );
  }

  Widget _buildLoadingView(SessionOperation operation) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          verticalSpace(16.h),
          Text(
            operation.message,
            style: TextStyle(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionEndedView(SessionState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 64.sp,
            color: Colors.green,
          ),
          verticalSpace(16.h),
          Text(
            'Session Ended Successfully',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          verticalSpace(8.h),
          Text(
            'Total attendance: ${state.session.attendanceList.length}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}