// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_cubit.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_state.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/active_session/server_info_card.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/active_session/session_info_card.dart';

class ActiveSessionView extends StatelessWidget {
  final Session session;
  final ServerInfo serverInfo;

  const ActiveSessionView({
    super.key,
    required this.session,
    required this.serverInfo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionMangementCubit, SessionManagementState>(
      listener: (context, state) {
        if (state is SessionState && state.showWarning) {
          _showWarningSnackBar(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: CustomScrollView(
          slivers: [
            BlocBuilder<SessionMangementCubit, SessionManagementState>(
              builder: (context, state) {
                if (state is SessionState && state.showWarning) {
                  return SliverToBoxAdapter(
                    child: _buildWarningBanner(),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            
            SliverToBoxAdapter(child: SessionInfoCard(session: session)),
            SliverToBoxAdapter(child: verticalSpace(10)),
            SliverToBoxAdapter(child: ServerInfoCard(serverInfo: serverInfo)),
            SliverToBoxAdapter(child: verticalSpace(20)),
            SliverToBoxAdapter(child: _buildEndSessionButton(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.shade300, width: 2),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 28.sp,
          ),
          horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⏰ Session Ending Soon',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
                verticalSpace(4.h),
                Text(
                  'Only 5 minutes remaining until auto-close',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 13.sp,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showWarningSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            horizontalSpace(12.w),
            Expanded(
              child: Text(
                '⏰ Session will end in 5 minutes!',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildEndSessionButton(BuildContext context) {
    return CustomAppButton(
      onPressed: () => _showEndSessionDialog(context),
      backgroundColor: AppColors.mainTextColorBlack,
      borderRadius: 20.r,
      width: double.infinity,
      height: 45.h,
      child: Text(
        'End Session',
        style: AppTextStyle.font14MediamGrey.copyWith(
          color: Colors.white,
          fontWeight: FontWeightHelper.medium,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  void _showEndSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('End Session'),
        content: Text(
          'Are you sure you want to end this session? '
          '${session.attendanceList.length} attendees have checked in.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.mainTextColorBlack),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SessionMangementCubit>().endSession();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }
}