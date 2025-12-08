import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';

class HomePage extends StatelessWidget {
  final String userRole;

  const HomePage({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Avatar and User Info (Clickable)
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(Routes.profilePage);
                    },
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            color: AppColors.buttonColorBlue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.sp,
                                fontWeight: FontWeightHelper.bold,
                              ),
                            ),
                          ),
                        ),
                        horizontalSpace(12),
                        // Name and Organization
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ahmed Mohammed',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeightHelper.bold,
                                color: AppColors.mainTextColorBlack,
                              ),
                            ),
                            Text(
                              'Sample University',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeightHelper.regular,
                                color: AppColors.buttonColorGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Right: Logout/Back Button
                  GestureDetector(
                    onTap: () {
                      context.pushReplacmentNamed(
                        Routes.registrationToOrganization,
                      );
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(24),

            // Main Dashboard Card
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: AppColors.backGroundColorWhite,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dashboard Header (Blue Section)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: AppColors.buttonColorBlue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeightHelper.regular,
                                  color: Colors.blue.shade100,
                                ),
                              ),
                              verticalSpace(8),
                              Text(
                                'Attendance Dashboard',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeightHelper.bold,
                                  color: Colors.white,
                                ),
                              ),
                              verticalSpace(8),
                              Text(
                                'Check in when session is active',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeightHelper.regular,
                                  color: Colors.blue.shade100,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Session Status (Green Section)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: AppColors.statusGreen,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16.r),
                              bottomRight: Radius.circular(16.r),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No active session',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeightHelper.medium,
                                  color: AppColors.statusGreenText,
                                ),
                              ),
                              verticalSpace(8),
                              Text(
                                'Wait for your organization to start a session',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeightHelper.regular,
                                  color: AppColors.statusGreenTextDark,
                                ),
                              ),
                            ],
                          ),
                        ),

                        verticalSpace(32),

                        // Action Buttons
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              // Take Attendance Button (Green)
                              CustomAppButton(
                                onPressed: () {
                                  // Handle take attendance action
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('No active session available'),
                                    ),
                                  );
                                },
                                backgroundColor: AppColors.buttonColorGreen,
                                borderRadius: 12.r,
                                child: Text(
                                  'Take Attendance',
                                  style: AppTextStyle.font15SemiBoldWhite.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeightHelper.bold,
                                  ),
                                ),
                              ),
                              verticalSpace(16),

                              // View Profile Button (Blue)
                              CustomAppButton(
                                onPressed: () {
                                  context.pushNamed(Routes.profilePage);
                                },
                                backgroundColor: AppColors.buttonColorBlue,
                                borderRadius: 12.r,
                                child: Text(
                                  'View Profile',
                                  style: AppTextStyle.font15SemiBoldWhite.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeightHelper.bold,
                                  ),
                                ),
                              ),
                              verticalSpace(24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

