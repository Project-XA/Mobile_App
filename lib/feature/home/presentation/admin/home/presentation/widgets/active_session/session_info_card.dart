import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/active_session/info_row_widget.dart';

class SessionInfoCard extends StatelessWidget {
  final Session session;

  const SessionInfoCard({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
              horizontalSpace(8.w),
              Text(
                'Session Active',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          verticalSpace(12.h),
          InfoRow(label: 'Session Name:', value: session.name),
          verticalSpace(8.h),
          InfoRow(label: 'Location:', value: session.location),
          verticalSpace(8.h),
          InfoRow(label: 'Connection:', value: session.connectionMethod),
          verticalSpace(8.h),
          InfoRow(
            label: 'Start Time:',
            value: DateFormat('hh:mm a').format(session.startTime),
          ),
          verticalSpace(8.h),
          InfoRow(
            label: 'Duration:',
            value: '${session.durationMinutes} minutes',
          ),
        ],
      ),
    );
  }
}
