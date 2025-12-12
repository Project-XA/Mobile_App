import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/utils/app_assets.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';
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

    return BlocProvider(
      create: (context) => AdminCubit(),
      child: Scaffold(
        backgroundColor: AppColors.backGroundColorWhite,
        body: SafeArea(
          child: Column(
            children: [
              UserHeader(
                userName: 'Ahmed Mohamed',
                userRole: 'Admin',
                userImage: Assets.assetsImagesUser,
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

                    // Toggle Tabs
                    BlocBuilder<AdminCubit, AdminState>(
                      builder: (context, state) {
                        int selectedIndex = 0;

                        if (state is ToggleTabChanged) {
                          selectedIndex = state.selectedIndex;
                        }

                        return ToggleTabs(
                          tabs: const ["Manage Sessions", "User Attendance"],
                          selectedIndex: selectedIndex,
                          onTabSelected: (index) {
                            context.read<AdminCubit>().changeTab(index);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: BlocBuilder<AdminCubit, AdminState>(
                  builder: (context, state) {
                    int selectedIndex = 0;

                    if (state is ToggleTabChanged) {
                      selectedIndex = state.selectedIndex;
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder: (child, animation) {
                          // Slide + Fade Animation
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: selectedIndex == 0
                            ? const ManageSessionsView()
                            : const UserAttendanceView(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
