import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/feature/registration_to_organization/presentation/logic/user_role_cubit.dart';

class RequestAccessButton extends StatelessWidget {
  final TextEditingController organizationIdController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RequestAccessButton({
    super.key,
    required this.organizationIdController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserRoleCubit, UserRoleState>(
      builder: (context, state) {
        final isLoading = state is UserRoleLoading;

        return CustomAppButton(
          onPressed: isLoading
              ? null
              : () {
                  final organizationCode = organizationIdController.text.trim();
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (organizationCode.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all fields'),
                      ),
                    );
                    return;
                  }

                  context.read<UserRoleCubit>().getUserRole(
                        organizationCode: organizationCode,
                        email: email,
                        password: password,
                      );
                },
          backgroundColor: AppColors.buttonColorBlue,
          borderRadius: 12.r,
          child: isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Request Access',
                  style: AppTextStyle.font15SemiBoldWhite.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.bold,
                  ),
                ),
        );
      },
    );
  }
}

