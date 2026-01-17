import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/init_verify_get_it.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/feature/verification/presentation/logic/verification_cubit.dart';
import 'package:mobile_app/feature/verification/presentation/logic/verification_state.dart';
import 'package:mobile_app/feature/verification/presentation/widgets/verification_header.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VerificationCubit>().opencamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    initVerifyScreen();
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<VerificationCubit, VerificationState>(
        listener: (context, state) {
          if (state.isVerificationComplete && !state.hasError) {
            Future.delayed(const Duration(seconds: 2), () {
              context.pushReplacmentNamed(Routes.registeScreen);
            });
          }
        },
        child: BlocBuilder<VerificationCubit, VerificationState>(
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  const VerificationHeader(),
                  Expanded(child: _buildBody(state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(VerificationState state) {
    // ✅ Show success screen
    if (state.isVerificationComplete && !state.isnotVerified) {
      return _buildSuccessState();
    }

    // ❌ Show failure screen
    if (state.isnotVerified) {
      return _buildFailedVerification();
    }

    if (state.isInitializing) {
      return _buildLoadingState();
    }

    if (state.hasPermissionDenied) {
      return _buildPermissionDeniedState();
    }

    if (state.hasError) {
      return _buildErrorState(state.errorMessage);
    }

    if (state.isCameraReady && state.controller != null) {
      return _buildCameraPreview(state);
    }

    return _buildLoadingState();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          verticalSpace(16),
          Text(
            'Initializing camera...',
            style: TextStyle(fontSize: 16.sp, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 100.sp,
              color: Colors.grey[400],
            ),
            verticalSpace(24),
            Text(
              'Camera Access Required',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(12),
            Text(
              'We need access to your camera to verify your identity',
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            verticalSpace(32),
            ElevatedButton(
              onPressed: () => context.read<VerificationCubit>().opencamera(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Grant Permission',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 100.sp, color: Colors.red[400]),
            verticalSpace(24),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(12),
            Text(
              errorMessage ?? 'An unexpected error occurred',
              style: TextStyle(fontSize: 14.sp, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            verticalSpace(32),
            ElevatedButton(
              onPressed: () => context.read<VerificationCubit>().retryCapture(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ SUCCESS STATE
  Widget _buildSuccessState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Animation Container
            Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade50,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.check_circle,
                size: 100.sp,
                color: Colors.green,
              ),
            ),
            verticalSpace(32),
            Text(
              'Verification Done!',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(12),
            Text(
              'Your identity has been successfully verified',
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            verticalSpace(24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 3,
            ),
            verticalSpace(16),
            Text(
              'Redirecting to registration...',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black45,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ❌ FAILED VERIFICATION STATE
  Widget _buildFailedVerification() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Failed Animation Container
            Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.shade50,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(Icons.cancel, size: 100.sp, color: Colors.red),
            ),
            verticalSpace(32),
            Text(
              'Verification Failed',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(12),
            Text(
              'The face in the selfie doesn\'t match the ID card photo',
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            verticalSpace(40),
            // Retry Button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  context.read<VerificationCubit>().retryCapture();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainTextColorBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: Colors.white, size: 24.sp),
                    horizontalSpace(12),
                    Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview(VerificationState state) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circular Camera Preview
                Container(
                  width: 320.w,
                  height: 320.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 4),
                  ),
                  child: ClipOval(child: CameraPreview(state.controller!)),
                ),

                // Processing Overlay
                if (state.isprocessing)
                  Container(
                    width: 320.w,
                    height: 320.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                        verticalSpace(16),
                        Text(
                          'Verifying your face...',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Verification Progress (after capture)
                if (state.hascaptured && !state.isprocessing)
                  Container(
                    width: 320.w,
                    height: 320.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '68%',
                          style: TextStyle(
                            fontSize: 64.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(8),
                        Text(
                          'Processing...',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            shadows: const [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Instruction Text
        if (!state.hascaptured && !state.isprocessing)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            child: Text(
              'Position your face within the circle',
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        // Buttons Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
          child: _buildActionButtons(state),
        ),
      ],
    );
  }

  Widget _buildActionButtons(VerificationState state) {
    if (state.isprocessing || state.hascaptured) {
      return const SizedBox.shrink();
    }

    // Show Capture button
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          context.read<VerificationCubit>().capturePhoto();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainTextColorBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, color: Colors.white, size: 24.sp),
            horizontalSpace(12),
            Text(
              'Capture Photo',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
