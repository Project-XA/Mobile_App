// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/utils/app_assets.dart';

class UserHeader extends StatelessWidget {
  final String userName;
  final String userRole;
  final String? userImage;
 

  const UserHeader({
    super.key,
    required this.userName,
    required this.userRole,
    this.userImage,
   
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 360;
        
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12.w : 16.w,
            vertical: 8.h,
          ),
          child: Row(
            children: [
              _UserAvatar(
                userImage: userImage,
                isSmallScreen: isSmallScreen,
              ),

              SizedBox(width: isSmallScreen ? 10.w : 12.w),

              Expanded(
                child: _UserInfo(
                  userName: userName,
                  userRole: userRole,
                  isSmallScreen: isSmallScreen,
                ),
              ),

              horizontalSpace(8.w),

           
            ],
          ),
        );
      },
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String? userImage;
  final bool isSmallScreen;

  const _UserAvatar({
    required this.userImage,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final size = isSmallScreen ? 45.w : 50.w;
    
    return Container(
      width: size,
      height: size,
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
          cacheWidth: (size * 2).toInt(), 
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  final String userName;
  final String userRole;
  final bool isSmallScreen;

  const _UserInfo({
    required this.userName,
    required this.userRole,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;
  final bool isSmallScreen;

  const _NotificationBadge({
    required this.count,
    required this.onTap,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final size = isSmallScreen ? 40.w : 45.w;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
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
            if (count > 0)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: _NotificationCounter(
                  count: count,
                  isSmallScreen: isSmallScreen,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCounter extends StatelessWidget {
  final int count;
  final bool isSmallScreen;

  const _NotificationCounter({
    required this.count,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(count > 9 ? 3 : 4),
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
          count > 99 ? '99+' : count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 8.sp : 9.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}