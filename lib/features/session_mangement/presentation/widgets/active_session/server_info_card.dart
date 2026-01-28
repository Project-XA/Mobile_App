import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/active_session/copyable_info_row_widget.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/active_session/info_row_widget.dart';

class ServerInfoCard extends StatelessWidget {
  final ServerInfo serverInfo;

  const ServerInfoCard({
    super.key,
    required this.serverInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.router, color: Colors.blue, size: 20.sp),
              horizontalSpace(8.w),
              Text(
                'Server Information',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeightHelper.semiBold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          verticalSpace(12.h),
          CopyableInfoRow(
            label: 'IP Address:',
            value: serverInfo.ipAddress,
          ),
          verticalSpace(8.h),
          InfoRow(
            label: 'Port:',
            value: serverInfo.port.toString(),
          ),
          verticalSpace(8.h),
          const CopyableInfoRow(
            label: 'mDNS:',
            value: 'attendance.local',
          ),
        ],
      ),
    );
  }
}
