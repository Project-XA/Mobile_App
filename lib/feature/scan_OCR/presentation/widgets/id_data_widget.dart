import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class IdDataWidget extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String idNumber;
  final String birthDate;

  const IdDataWidget({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.idNumber,
    required this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.backGroundColorWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainTextColorBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow('First Name:', firstName),
          verticalSpace(12.h),
          _buildInfoRow('Last Name:', lastName),
          verticalSpace(12.h),
          _buildInfoRow('ID Number:', idNumber),
          verticalSpace(12.h),
          _buildInfoRow('Birthdate:', birthDate),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.font14MediamGrey),
        Text(
          value,
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontWeight: FontWeightHelper.semiBold,
            color: AppColors.mainTextColorBlack,
          ),
        ),
      ],
    );
  }
}
