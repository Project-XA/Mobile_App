import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/feature/home/presentation/widgets/attendance_actions.dart';
import 'package:mobile_app/feature/home/presentation/widgets/attendance_dashboard_card.dart';
import 'package:mobile_app/feature/home/presentation/widgets/home_header.dart';

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
            // Fixed Header at the top
            const HomeHeader(),
            
            // Scrollable Content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 500.w, // keeps layout nice on tablets / large screens
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        verticalSpace(24),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: const AttendanceDashboardCard(),
                        ),
                        verticalSpace(32),
                        const AttendanceActions(),
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

