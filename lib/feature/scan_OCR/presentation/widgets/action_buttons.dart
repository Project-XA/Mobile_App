import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/auth_state_service.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_cubit.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';

class ActionButtons extends StatelessWidget {
  final CameraState state;

  const ActionButtons({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isProcessing) {
      return _buildProcessingIndicator();
    }

    if (state.showResult) {
      return _buildVerifyAndRetakeButtons(context);
    }

    if (state.hasError) {
      return _buildErrorState(context);
    }

    return _buildCaptureButton(context);
  }

  Widget _buildProcessingIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.mainTextColorBlack.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child:const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.mainTextColorBlack,
              ),
            ),
          ),
          horizontalSpace( 12.w),
          Text(
            "Processing ID Card...",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeightHelper.semiBold,
              color: AppColors.mainTextColorBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyAndRetakeButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomAppButton(
            onPressed: () async {
              try {
                await context.read<CameraCubit>().verifyAndSaveData();
                
                if (context.mounted) {
                  final authStateService = getIt<AuthStateService>();
                  await authStateService.markOCRComplete();
                  
                  context.pushNamed(Routes.registeScreen);
                }
              } catch (e) {
                if (context.mounted) {
                  _showErrorDialog(context, 'Failed to save data: $e');
                }
              }
            },
            backgroundColor: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check, color: Colors.white),
                horizontalSpace(8.w),
                Text(
                  "Verify",
                  style: AppTextStyle.font15SemiBoldWhite.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        horizontalSpace(12.w),
        Expanded(
          child: CustomAppButton(
            onPressed: () {
              context.read<CameraCubit>().retakePhoto();
            },
            backgroundColor: Colors.orange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  "Retake",
                  style: AppTextStyle.font15SemiBoldWhite.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700, size: 24),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  "Invalid photo! Please capture a valid ID card.",
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        verticalSpace( 12.h),
        SizedBox(
          width: double.infinity,
          child: CustomAppButton(
            onPressed: () => context.read<CameraCubit>().retakePhoto(),
            backgroundColor: Colors.orange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  "Retake Photo",
                  style: AppTextStyle.font15SemiBoldWhite.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaptureButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomAppButton(
        onPressed: state.isOpened && !state.hasCaptured
            ? () => context.read<CameraCubit>().capturePhoto()
            : null,
        backgroundColor: state.isOpened && !state.hasCaptured
            ? AppColors.mainTextColorBlack
            // ignore: deprecated_member_use
            : AppColors.subTextColorGrey.withOpacity(0.5),
        child: Text(
          "Capture",
          style: AppTextStyle.font15SemiBoldWhite.copyWith(fontSize: 16.sp),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}