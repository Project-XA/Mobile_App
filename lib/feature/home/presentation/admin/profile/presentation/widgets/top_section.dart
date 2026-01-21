import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/onboarding_service.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/curren_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/curren_user/presentation/cubits/current_user_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/widgets/profile_image_section.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/widgets/user_info_section.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        final user = context.read<CurrentUserCubit>().currentUser;
        
        if (user == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.mainTextColorBlack,
                AppColors.mainTextColorBlack.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Logout Button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => _showLogoutDialog(context),
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Profile Image
                const ProfileImageSection(),

                verticalSpace(10.h),

                UserNameSection(fullNameEn: user.fullNameEn),

                verticalSpace(5.h),

                if (user.email != null) UserEmailSection(email: user.email!),

                verticalSpace(5.h),

                if (user.organizations != null &&
                    user.organizations!.isNotEmpty)
                  UserRoleSection(role: user.organizations!.first.role),

                verticalSpace(10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: Text(
          'Logout',
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyle.font14MediamGrey,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              // Close dialog first
              Navigator.pop(ctx);

              try {
                final onboardingService = getIt<OnboardingService>();
                await onboardingService.logout();

                if (!context.mounted) return;

                context.pushNameAndRemoveUntil(
                  Routes.registeScreen,
                  predicate: (route) => false,
                );
              } catch (e) {
                debugPrint('Logout error: $e');
                
                if (!context.mounted) return;
                
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logout failed: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainTextColorBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}