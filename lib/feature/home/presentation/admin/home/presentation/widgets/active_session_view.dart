// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/models/server_info.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/active_session/server_info_card.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/active_session/session_info_card.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SessionInfoCard(session: session)),
          SliverToBoxAdapter(child: ServerInfoCard(serverInfo: serverInfo)),
          SliverToBoxAdapter(child: verticalSpace(20)),
          SliverToBoxAdapter(child: _buildEndSessionButton(context)),
        ],
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
              context.read<AdminCubit>().endSession();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }
}
