import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_cubit.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';

class CameraBox extends StatelessWidget {
  const CameraBox({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return Container(
          width: width,
          height: height * 0.30,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade400, width: 2),
            color: Colors.grey.shade100,
          ),
          child: state.isInitializing
              ? const Center(child: CircularProgressIndicator())
              : !state.isOpened
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    const Text(
                      "Ready to scan",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    CustomAppButton(
                      width: width * 0.4,
                      backgroundColor: AppColors.mainTextColorBlack,

                      onPressed: () => context.read<CameraCubit>().openCamera(),
                      child: Text(
                        "Open Camera",
                        style: AppTextStyle.font15SemiBoldWhite,
                      ),
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: state.controller!.value.previewSize!.height,
                        height: state.controller!.value.previewSize!.width,
                        child: CameraPreview(state.controller!),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
