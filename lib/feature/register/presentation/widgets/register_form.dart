import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/app_regex.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _orgIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _orgIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      debugPrint('Organization ID: ${_orgIdController.text}');
      debugPrint('Email: ${_emailController.text}');
      debugPrint('Password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Account Information'),
          verticalSpace(15.h),
          _buildOrgIdField(),
          verticalSpace(15.h),
          _buildEmailField(),
          verticalSpace(15.h),
          _buildPasswordField(),
          verticalSpace(20.h),

          _buildRegisterButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyle.font18BoldBlack.copyWith(
        fontSize: 20.sp,
        fontWeight: FontWeightHelper.bold,
        color: AppColors.mainTextColorBlack,
      ),
    );
  }

  Widget _buildOrgIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Organization ID', Icons.business_rounded),
        verticalSpace(8.h),
        AppTextFormField(
          controller: _orgIdController,
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.h,
            horizontal: 20.w,
          ),
          borderRadius: 16.r,
          focusedBorderColor: AppColors.mainTextColorBlack,
          enabledBorderColor: Colors.grey.shade300,
          hintText: 'Enter your organization ID',
          labelStyle: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade400,
            fontWeight: FontWeightHelper.regular,
          ),
          textStyle: AppTextStyle.font18BoldBlack.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.medium,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Organization ID is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Email Address', Icons.email_rounded),
        verticalSpace(8.h),
        AppTextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.h,
            horizontal: 20.w,
          ),
          borderRadius: 16.r,
          focusedBorderColor: AppColors.mainTextColorBlack,
          enabledBorderColor: Colors.grey.shade300,
          hintText: 'example@email.com',
          labelStyle: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade400,
            fontWeight: FontWeightHelper.regular,
          ),
          textStyle: AppTextStyle.font18BoldBlack.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.medium,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!AppRegex.isEmailValid(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Password', Icons.lock_rounded),
        verticalSpace(8.h),
        AppTextFormField(
          controller: _passwordController,
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.h,
            horizontal: 20.w,
          ),
          borderRadius: 16.r,
          focusedBorderColor: AppColors.mainTextColorBlack,
          enabledBorderColor: Colors.grey.shade300,
          hintText: 'Enter your password',
          labelStyle: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade400,
            fontWeight: FontWeightHelper.regular,
          ),
          textStyle: AppTextStyle.font18BoldBlack.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.medium,
          ),
          obscureText: !_isPasswordVisible,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              color: Colors.grey.shade500,
              size: 22.sp,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: AppColors.mainTextColorBlack.withOpacity(0.7),
        ),
        horizontalSpace(6.w),
        Text(
          label,
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.semiBold,
            color: AppColors.mainTextColorBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return CustomAppButton(
      onPressed: _isLoading ? null : _handleRegister,
      backgroundColor: AppColors.mainTextColorBlack,
      borderRadius: 16.r,
      width: double.infinity,
      height: 46.h,
      child: _isLoading
          ? SizedBox(
              height: 24.h,
              width: 24.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Account',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeightHelper.semiBold,
                    fontSize: 16.sp,
                    letterSpacing: 0.3,
                  ),
                ),
                horizontalSpace(8.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ],
            ),
    );
  }
}