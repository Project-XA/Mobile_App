import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Container(
          width: 70.w,
          height: 70.h,
          child: ClipRect(),
        )
      ],)),


    );
  }
}
