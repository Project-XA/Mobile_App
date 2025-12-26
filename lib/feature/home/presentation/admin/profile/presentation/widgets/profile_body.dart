import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/logic/user_profile_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/logic/user_profile_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/widgets/profile_info_card.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      buildWhen: (previous, current) => current is UserProfileLoaded,
      builder: (context, state) {
        if (state is! UserProfileLoaded) return const SizedBox.shrink();

        final user = state.user;

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: AppTextStyle.font14MediamGrey.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainTextColorBlack,
                ),
              ),
              verticalSpace(15.h),

              FirstNameCard(firstNameAr: user.firstNameEn!),

              verticalSpace(12.h),

              LastNameCard(lastNameAr: user.lastNameEn!),

              verticalSpace(12.h),

              if (user.email != null) EmailCard(email: user.email!),

              verticalSpace(12.h),

              NationalIdCard(nationalId: user.nationalId),

              verticalSpace(12.h),

              if (user.address != null) AddressCard(address: user.address!),

              verticalSpace(12.h),

              if (user.birthDate != null)
                BirthDateCard(birthDate: user.birthDate!),
            ],
          ),
        );
      },
    );
  }
}
