import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/DI/register_get_it.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/feature/register/presentation/logic/register_cubit.dart';
import 'widgets/register_header.dart';
import 'widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    initRegister();
    return BlocProvider(
      create: (context) => getIt<RegisterCubit>(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Scaffold(
          backgroundColor: AppColors.backGroundColorWhite,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [_buildTopSection(context), _buildMainContent()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mainTextColorBlack,
            // ignore: deprecated_member_use
            AppColors.mainTextColorBlack.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          verticalSpace(50.h),
          const RegisterHeader(),
          verticalSpace(20.h),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          verticalSpace(20.h),
          const RegisterForm(),
          verticalSpace(20.h),
        ],
      ),
    );
  }
}
