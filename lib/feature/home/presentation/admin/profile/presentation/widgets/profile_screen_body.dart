import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/services/toast_service.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/logic/user_profile_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/logic/user_profile_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/widgets/top_section.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/widgets/profile_body.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColorWhite,
      body: BlocListener<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileFailure) {
            showToast(message: state.message, type: ToastType.error);
          } else if (state is ProfileImageUpdated) {
            showToast(
              message: 'Profile image updated successfully',
              type: ToastType.success,
            );
          } else if (state is ProfileUpdated) {
            Navigator.pop(context);
            showToast(
              message: 'Profile updated successfully',
              type: ToastType.success,
            );
          }
        },
        child: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainTextColorBlack,
                ),
              );
            }

            if (state is UserProfileLoaded) {
              return const Column(
                children: [
                  TopSection(),
                  Expanded(child: ProfileBody()),
                ],
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60.sp, color: Colors.grey),
                  verticalSpace(20.h),
                  Text(
                    'No user data found',
                    style: AppTextStyle.font14MediamGrey,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
