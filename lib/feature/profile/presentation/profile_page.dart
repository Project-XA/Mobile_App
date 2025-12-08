import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.mainTextColorBlack,
          ),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeightHelper.bold,
            color: AppColors.mainTextColorBlack,
          ),
        ),
        backgroundColor: AppColors.backGroundColorWhite,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 80.sp,
              color: AppColors.buttonColorBlue,
            ),
            SizedBox(height: 24.h),
            Text(
              'Profile Page',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeightHelper.bold,
                color: AppColors.mainTextColorBlack,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Profile information will be displayed here',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.subTextColorGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

