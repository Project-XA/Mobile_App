// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/DI/scan_ocr_di.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/camera_box.dart';
// import 'package:mobile_app/feature/scan_OCR/presentation/widgets/cropped_field.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/id_data_widget.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/scan_header.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/action_buttons.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/permission_denied_widget.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_cubit.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';

class ScanIdScreen extends StatefulWidget {
  const ScanIdScreen({super.key});

  @override
  State<ScanIdScreen> createState() => _ScanIdScreenState();
}

class _ScanIdScreenState extends State<ScanIdScreen> {
  Timer? _redirectTimer;

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  void _handlePermissionDenied(BuildContext context) {
    _redirectTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.pushReplacmentNamed(Routes.startPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScanOcrFeature();

    return BlocProvider(
      create: (context) => getIt<CameraCubit>()..openCamera(),
      child: Scaffold(
        backgroundColor: AppColors.backGroundColorWhite,
        appBar: _buildAppBar(context),
        body: BlocConsumer<CameraCubit, CameraState>(
          listener: (context, state) {
            if (state.hasPermissionDenied) {
              _handlePermissionDenied(context);
            }
          },
          builder: (context, state) {
            if (state.hasPermissionDenied) {
              return const Center(child: PermissionDeniedWidget());
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScanHeader(),
                  verticalSpace(30),

                  if (!state.showResult || state.finalData == null) ...[
                    const CameraBox(),
                    verticalSpace(20),
                  ],

                  if (state.showResult && state.finalData != null) ...[
                    IdDataWidget(
                      firstName: state.finalData!['firstName'] ?? 'N/A',
                      lastName: state.finalData!['lastName'] ?? 'N/A',
                    ),
                    verticalSpace(20),
                    // Expanded(
                    //   child: CroppedFieldsViewer(
                    //     croppedFields: state.croppedFields!,
                    //     extractedText: state.finalData,
                    //   ),
                    // ),
                  ],

                  const Spacer(),

                  ActionButtons(state: state),
                  verticalSpace(20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backGroundColorWhite,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        'ID Verification',
        style: TextStyle(
          fontWeight: FontWeightHelper.semiBold,
          fontSize: 18.sp,
          color: AppColors.mainTextColorBlack,
        ),
      ),
    );
  }
}
