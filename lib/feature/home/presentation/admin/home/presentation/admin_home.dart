import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/DI/init_admin_home.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/utils/app_assets.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/admin_home_shimmer.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/manage_session_view.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/user_attendency_view.dart';
import 'package:mobile_app/feature/home/presentation/widgets/info_card.dart';
import 'package:mobile_app/feature/home/presentation/widgets/toggle_taps.dart';
import 'package:mobile_app/feature/home/presentation/widgets/user_header.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    initAdminHome();

    return BlocProvider(
      create: (context) => getIt<AdminCubit>()..loadUser(),
      child: Scaffold(
        backgroundColor: AppColors.backGroundColorWhite,
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            // Loading state
            if (state is AdminLoading || state is AdminInitial) {
              return const AdminHomeShimmer();
            }

            // Error state
            if (state is AdminError) {
              return _buildErrorView(context, state.message);
            }

            // Get user from state
            final user = state is AdminStateWithUser ? state.user : null;

            if (user == null) {
              return const Center(child: Text('No user data'));
            }

            return SafeArea(
              child: Column(
                children: [
                  UserHeader(
                    userName: user.fullNameEn,
                    userRole: user.organizations?.first.role ?? 'Admin',
                    userImage: user.profileImage ?? Assets.assetsImagesUser,
                    notificationCount: 5,
                    onNotificationTap: () {},
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

                        _buildToggleTabs(state),
                      ],
                    ),
                  ),

                  Expanded(child: _buildContent(state)),
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
            onPressed: () => context.read<AdminCubit>().loadUser(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTabs(AdminState state) {
    final selectedIndex = state is AdminStateWithUser 
        ? state.selectedTabIndex 
        : 0;

    return BlocBuilder<AdminCubit, AdminState>(
      buildWhen: (previous, current) {
        // Only rebuild when tab index changes
        if (previous is AdminStateWithUser && current is AdminStateWithUser) {
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
    final selectedIndex = state is AdminStateWithUser 
        ? state.selectedTabIndex 
        : 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: IndexedStack(
        index: selectedIndex,
        children: const [
          ManageSessionsView(),
          UserAttendanceView(),
        ],
      ),
    );
  }
}