// feature/scan_OCR/presentation/widgets/camera_box.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_cubit.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/widgets/id_crad_frame_painter.dart';

class CameraBox extends StatelessWidget {
  const CameraBox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: 280.h, 
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getBorderColor(state),
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _buildContent(state),
          ),
        );
      },
    );
  }

  Widget _buildContent(CameraState state) {
    if (state.isProcessing) {
      return _buildProcessingPlaceholder();
    }

    if (state.isInitializing) {
      return _buildLoadingState('Initializing Camera...');
    }

    if (state.isOpened && state.controller != null) {
      return _buildCameraPreview(state.controller!);
    }

    if (state.hasError) {
      return _buildErrorState();
    }

    return _buildIdleState();
  }

  Widget _buildProcessingPlaceholder() {
    return Container(
      color: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated processing icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (value * 0.2),
                child: Icon(
                  Icons.credit_card,
                  size: 60, 
                  color: Colors.white.withOpacity(0.5 + (value * 0.5)),
                ),
              );
            },
            onEnd: () {
              // Loop animation
            },
          ),
          SizedBox(height: 16.h),
          const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
          SizedBox(height: 12.h),
          Text(
            'Processing ID Card...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp, // ✅ صغرت الخط
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Please wait',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview(CameraController controller) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(controller),
        // ID Card frame overlay
        CustomPaint(
          painter: IdCardFramePainter(),
        ),
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              'Align ID card within the frame',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                shadows: const [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 12.h),
          Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
          SizedBox(height: 12.h),
          Text(
            'Camera Error',
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            'Please try again',
            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildIdleState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, color: Colors.white54, size: 48.sp),
          SizedBox(height: 12.h),
          Text(
            'Camera Not Active',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Color _getBorderColor(CameraState state) {
    if (state.showResult) return Colors.green;
    if (state.hasError) return Colors.red;
    if (state.isProcessing) return Colors.orange;
    if (state.isOpened) return AppColors.mainTextColorBlack;
    return Colors.grey;
  }
}

