import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class PermissionDeniedWidget extends StatelessWidget {
  const PermissionDeniedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.5 + (value * 0.5),
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 64.sp,
                    color: Colors.orange.shade700.withOpacity(value),
                  ),
                ),
              );
            },
          ),
          
          verticalSpace(24.h),
          
          Text(
            'Camera Permission Required',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColorBlack,
            ),
          ),
          
          verticalSpace(12.h),
          
          Text(
            'To scan your ID card, we need access to your camera.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.subTextColorGrey,
              height: 1.5,
            ),
          ),
          
          verticalSpace(24.h),
          
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.orange.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to enable camera access:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainTextColorBlack,
                  ),
                ),
                verticalSpace(12.h),
                _buildStep('1', 'Go to your phone Settings'),
                verticalSpace(8.h),
                _buildStep('2', 'Find this app in the apps list'),
                verticalSpace(8.h),
                _buildStep('3', 'Enable Camera permission'),
                verticalSpace(8.h),
                _buildStep('4', 'Return to the app'),
              ],
            ),
          ),
          
          verticalSpace(24.h),
          
          Text(
            'Redirecting to home screen...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.subTextColorGrey.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: Colors.orange.shade700,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        horizontalSpace(12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.mainTextColorBlack.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}