import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';

class InvalidCardWidget extends StatelessWidget {
  const InvalidCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.red.shade300,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated error icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.5 + (value * 0.5),
                child: Icon(
                  Icons.credit_card_off,
                  size: 64.sp,
                  color: Colors.red.shade600.withOpacity(value),
                ),
              );
            },
          ),
          verticalSpace(16.h),

          Text(
            'Invalid Image',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade900,
            ),
          ),
          verticalSpace(8.h),

          Text(
            'The captured image does not appear to be a valid ID card',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.red.shade700,
              height: 1.4,
            ),
          ),
          verticalSpace(12.h),

          // Tips container
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips for better results:',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade900,
                  ),
                ),
                verticalSpace(8.h),
                _buildTip('Ensure the ID card is fully visible'),
                verticalSpace(4.h),
                _buildTip('Align the card within the frame'),
                verticalSpace(4.h),
                _buildTip('Use good lighting conditions'),
                verticalSpace(4.h),
                _buildTip('Avoid glare and shadows'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 16.sp,
          color: Colors.red.shade700,
        ),
        horizontalSpace(8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.red.shade800,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}