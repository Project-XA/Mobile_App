import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/utils/app_assets.dart';

class UserHeader extends StatelessWidget {
  final String userName;
  final String userRole;
  final String? userImage;
  final int notificationCount;
  final VoidCallback? onNotificationTap;

  const UserHeader({
    super.key,
    required this.userName,
    required this.userRole,
    this.userImage,
    this.notificationCount = 0,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12.w : 16.w,
        vertical: 8.h,
      ),
      child: Row(
        children: [
          // User Image Container
          Container(
            width: isSmallScreen ? 45.w : 50.w,
            height: isSmallScreen ? 45.w : 50.w,
            decoration: BoxDecoration(
              color: AppColors.backGroundColorWhite,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
                userImage ?? Assets.assetsImagesUser,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: isSmallScreen ? 10.w : 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    color: AppColors.mainTextColorBlack,
                    fontSize: isSmallScreen ? 14.sp : 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                verticalSpace(2.h),
                Text(
                  userRole,
                  style: TextStyle(
                    color: AppColors.mainTextColorBlack.withOpacity(0.8),
                    fontSize: isSmallScreen ? 11.sp : 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),

          horizontalSpace(8.w),

          GestureDetector(
            onTap: onNotificationTap,
            child: Container(
              width: isSmallScreen ? 40.w : 45.w,
              height: isSmallScreen ? 40.w : 45.w,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: AppColors.mainTextColorBlack,
                    size: isSmallScreen ? 22.sp : 24.sp,
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.all(notificationCount > 9 ? 3 : 4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: isSmallScreen ? 16.w : 18.w,
                          minHeight: isSmallScreen ? 16.w : 18.w,
                        ),
                        child: Center(
                          child: Text(
                            notificationCount > 99
                                ? '99+'
                                : notificationCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 8.sp : 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
