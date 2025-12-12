// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/camera_box.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/id_data_widget.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/scan_header.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/action_buttons.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_cubit.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';

class ScanIdScreen extends StatelessWidget {
  const ScanIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CameraCubit>()..openCamera(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: BlocBuilder<CameraCubit, CameraState>(
          builder: (context, state) {
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
                    // Expanded(
                    //   child: SingleChildScrollView(
                    //     child: CroppedFieldsViewer(
                    //       croppedFields: state.croppedFields ?? [],
                    //       extractedText: state.extractedText,
                    //     ),
                    //   ),
                    // ),
                    IdDataWidget(
                      firstName: state.finalData!['firstName'] ?? 'N/A',
                      lastName: state.finalData!['lastName'] ?? 'N/A',
                      //  idNumber: state.finalData!['nid'] ?? 'N/A',
                    ),
                    verticalSpace(20),
                  ],

                  // Spacer
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
      leading: IconButton(
        onPressed: () => context.pop(),
        icon:const Icon(
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
    );
  }
}
