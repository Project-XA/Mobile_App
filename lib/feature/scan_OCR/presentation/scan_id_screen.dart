import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/camera_box.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/id_data_widget.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_cubit.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';
import 'package:mobile_app/feature/scan_OCR/data/repo_imp/camera_reo_imp.dart';

class ScanIdScreen extends StatelessWidget {
  const ScanIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraCubit(CameraRepImp()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.mainTextColorBlack,
            ),
          ),
          centerTitle: true,
          title: Text(
            'ID Verification',
            style: TextStyle(
              fontWeight: FontWeightHelper.semiBold,
              fontSize: 18.sp,
              color: AppColors.mainTextColorBlack,
            ),
          ),
        ),
        body: BlocBuilder<CameraCubit, CameraState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Scan Your ID",
                    style: AppTextStyle.font18BoldBlack.copyWith(
                      fontSize: 24.sp,
                    ),
                  ),
                  verticalSpace(10),
                  Text(
                    "Please scan your ID to confirm verification process.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.subTextColorGrey,
                    ),
                  ),
                  verticalSpace(30),

                  // Camera Box
                  const CameraBox(),

                  verticalSpace(20),

                  if (state.showResult) ...[
                    const IdDataWidget(
                      firstName: 'Ahmed',
                      lastName: 'Mohammed',
                      idNumber: '30001011234567',
                      birthDate: '01/01/1990',
                    ),
                    verticalSpace(20),
                  ],

                  const Spacer(),

                  // الأزرار
                  _buildActionButtons(context, state),

                  verticalSpace(20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, CameraState state) {
    if (state.isProcessing) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.mainTextColorBlack.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.mainTextColorBlack,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              "Processing...",
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

    if (state.showResult) {
      return Row(
        children: [
          Expanded(
            child: CustomAppButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ID Verified Successfully!')),
                );
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

    return SizedBox(
      width: double.infinity,
      child: CustomAppButton(
        onPressed: state.isOpened && !state.hasCaptured
            ? () => context.read<CameraCubit>().capturePhoto()
            : null,
        backgroundColor: state.isOpened && !state.hasCaptured
            ? AppColors.mainTextColorBlack
            : AppColors.subTextColorGrey.withOpacity(0.5),
        child: Text(
          "Capture",
          style: AppTextStyle.font15SemiBoldWhite.copyWith(fontSize: 16.sp),
        ),
      ),
    );
  }
}
