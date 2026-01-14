// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/DI/init_user_home.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/utils/app_assets.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/logic/user_cubit.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/logic/user_state.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/widgets/active_session_card.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/widgets/attendence_status_card.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/widgets/check_in_view.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/widgets/no_session_card.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/widgets/searching_session_card.dart';
import 'package:mobile_app/feature/home/presentation/widgets/info_card.dart';
import 'package:mobile_app/feature/home/presentation/widgets/user_header.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _searchTimer;
  int _searchSecondsRemaining = 30;
  final int _totalSearchDuration = 30;

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  void _startSearchTimer() {
    _searchTimer?.cancel();
    setState(() => _searchSecondsRemaining = _totalSearchDuration);

    _searchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_searchSecondsRemaining > 0) {
            _searchSecondsRemaining--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  void _stopSearchTimer() {
    _searchTimer?.cancel();
    if (mounted) {
      setState(() => _searchSecondsRemaining = _totalSearchDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    initUserHome();

    return BlocProvider(
      create: (context) => getIt<UserCubit>()..loadUser(),
      child: Scaffold(
        backgroundColor: AppColors.backGroundColorWhite,
        body: BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            if (state is SessionDiscoveryActive && state.isSearching) {
              _startSearchTimer();
            } else {
              _stopSearchTimer();
            }
          },
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoading || state is UserInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is UserError) {
                return _buildErrorView(context, state.message);
              }

              final user = state is UserStateWithUser ? state.user : null;
              if (user == null) {
                return const Center(child: Text('No user data'));
              }

              return SafeArea(
                child: Column(
                  children: [
                    UserHeader(
                      userName: user.fullNameEn,
                      userRole: user.organizations?.first.role ?? 'Student',
                      userImage: user.profileImage ?? Assets.assetsImagesUser,
                    ),
                    verticalSpace(20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12.w : 20.w,
                        vertical: 8.h,
                      ),
                      child: const InfoCard(
                        title: 'Welcome Back!',
                        subtitle: 'Assuit University',
                        description: 'Check attendance and active sessions',
                      ),
                    ),
                    verticalSpace(20.h),
                    Expanded(child: _buildContent(context, state)),
                  ],
                ),
              );
            },
          ),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              message,
              style: TextStyle(fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
          ),
          verticalSpace(16.h),
          ElevatedButton(
            onPressed: () => context.read<UserCubit>().loadUser(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserState state) {
    if (state is CheckInState) {
      return CheckInView(state: state);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActiveSessionCard(context, state),
          verticalSpace(20.h),
          _buildMyAttendanceSection(context, state),
          verticalSpace(20.h),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard(BuildContext context, UserState state) {
    // ✅ Check for both activeSession AND discoveredSessions
    final hasActiveSession = state is SessionDiscoveryActive &&
        (state.activeSession != null || state.discoveredSessions.isNotEmpty) &&
        !state.isSearching;

    final isSearching = state is SessionDiscoveryActive && state.isSearching;

    // Show searching card
    if (isSearching) {
      return SearchingSessionsCard(
        searchSecondsRemaining: _searchSecondsRemaining,
        totalSearchDuration: _totalSearchDuration,
      );
    }

    // Show active session card
    if (hasActiveSession) {
      final sessionState = state;
      final session = sessionState.activeSession ?? sessionState.discoveredSessions.first;
      return ActiveSessionCard(session: session);
    }

    // Show no sessions card
    return NoSessionsCard(
      isIdle: state is UserIdle,
      isDiscoveryActive: state is SessionDiscoveryActive,
    );
  }

  Widget _buildMyAttendanceSection(BuildContext context, UserState state) {
    final stats = state is UserStateWithUser
        ? (state is SessionDiscoveryActive
              ? state.stats
              : state is UserIdle
              ? state.stats
              : null)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Attendance',
              style: AppTextStyle.font14MediamGrey.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 13.sp,
                  color: AppColors.mainTextColorBlack,
                ),
              ),
            ),
          ],
        ),
        verticalSpace(12.h),
        if (stats != null) AttendanceStatsCard(stats: stats),
      ],
    );
  }
}