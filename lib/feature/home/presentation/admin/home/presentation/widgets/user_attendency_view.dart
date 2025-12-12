import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';

class UserAttendanceView extends StatelessWidget {
  const UserAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_alt,
            size: 80.sp,
            color: Colors.green.withOpacity(0.5),
          ),
          verticalSpace(16.h),
          Text(
            'User Attendance',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          verticalSpace( 8.h),
          Text(
            'View user attendance records',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
