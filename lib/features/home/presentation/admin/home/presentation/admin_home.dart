import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/curren_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/curren_user/presentation/cubits/current_user_state.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/utils/app_assets.dart';
import 'package:mobile_app/core/widgets/info_card.dart';
import 'package:mobile_app/core/widgets/toggle_taps.dart';
import 'package:mobile_app/core/widgets/user_header.dart';
import 'package:mobile_app/features/home/presentation/admin/home/presentation/logic/admin_cubit.dart';
import 'package:mobile_app/features/home/presentation/admin/home/presentation/logic/admin_state.dart';
import 'package:mobile_app/features/home/presentation/admin/home/presentation/widgets/admin_home_shimmer.dart';
import 'package:mobile_app/features/home/presentation/admin/home/presentation/widgets/manage_session_view.dart';
import 'package:mobile_app/features/home/presentation/admin/home/presentation/widgets/user_attendency_view.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    return BlocProvider(
      create: (context) => getIt<AdminCubit>()..loadStats(),
      child: Scaffold(
        backgroundColor: AppColors.backGroundColorWhite,
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, adminState) {
            // Loading state
            if (adminState is AdminLoading || adminState is AdminInitial) {
              return const AdminHomeShimmer();
            }

            // Error state
            if (adminState is AdminError) {
              return _buildErrorView(context, adminState.message);
            }

            final currentUserCubit = context.read<CurrentUserCubit>();
            final user = currentUserCubit.currentUser;

            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SafeArea(
              child: Column(
                children: [
                  BlocBuilder<CurrentUserCubit, CurrentUserState>(
                    builder: (context, userState) {
                      final latestUser = currentUserCubit.currentUser;
                      return UserHeader(
                        userName: latestUser?.fullNameEn ?? '',
                        userRole:
                            latestUser?.organizations?.first.role ?? 'Admin',
                        userImage:
                            latestUser?.profileImage ?? Assets.assetsImagesUser,
                      );
                    },
                  ),

                  verticalSpace(20),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12.w : 20.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      children: [
                        const InfoCard(
                          title: 'Admin Control Panel',
                          subtitle: 'Assuit University',
                          description: 'Unique sessions and attendance',
                        ),

                        verticalSpace(16.h),

                        _buildToggleTabs(adminState),
                      ],
                    ),
                  ),

                  Expanded(child: _buildContent(adminState)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
          verticalSpace(16.h),
          Text(
            message,
            style: TextStyle(fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
          verticalSpace(16.h),
          ElevatedButton(
            onPressed: () => context.read<AdminCubit>().loadStats(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTabs(AdminState state) {
    final selectedIndex = state is AdminStateWithTab
        ? state.selectedTabIndex
        : 0;

    return BlocBuilder<AdminCubit, AdminState>(
      buildWhen: (previous, current) {
        if (previous is AdminStateWithTab && current is AdminStateWithTab) {
          return previous.selectedTabIndex != current.selectedTabIndex;
        }
        return true;
      },
      builder: (context, state) {
        return ToggleTabs(
          tabs: const ["Manage Sessions", "User Attendance"],
          selectedIndex: selectedIndex,
          onTabSelected: (index) => context.read<AdminCubit>().changeTab(index),
        );
      },
    );
  }

  Widget _buildContent(AdminState state) {
    final selectedIndex = state is AdminStateWithTab
        ? state.selectedTabIndex
        : 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: IndexedStack(
        index: selectedIndex,
        children: const [ManageSessionsView(), UserAttendanceView()],
      ),
    );
  }
}
