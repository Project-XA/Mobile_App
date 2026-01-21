import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/utils/app_assets.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/feature/start_screen/widgets/step_item.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.backGroundColorWhite,
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isTablet = constraints.maxWidth > 600;
            bool isLargeScreen = constraints.maxWidth > 900;

            double logoSize = isLargeScreen
                ? constraints.maxWidth * 0.45
                : isTablet
                ? constraints.maxWidth * 0.6
                : constraints.maxWidth * 1;

            double textFont = isTablet ? 20 : 18;
            double descFont = isTablet ? 16 : 14;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 48.0 : 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    verticalSpace(size.height * 0.05),

                    Image.asset(
                      Assets.assetsImagesAttendoLogo,
                      width: logoSize,
                    ),

                    verticalSpace(15),

                    Text(
                      "Welcome to Attendo",
                      style: TextStyle(
                        color: AppColors.mainTextColorBlack,
                        fontSize: textFont.sp,
                        fontWeight: FontWeightHelper.bold,
                      ),
                    ),

                    verticalSpace(8),

                    Text(
                      "Follow the steps below to continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.subTextColorGrey,
                        fontSize: descFont.sp,
                        fontWeight: FontWeightHelper.medium,
                      ),
                    ),

                    verticalSpace(30),

                    /// STEPS
                    const Column(
                      children: [
                        StepItem(
                          icon: Icons.phone_android,
                          title: "Device Registration",
                          subtitle: "One-time setup on this device",
                        ),
                        StepItem(
                          icon: Icons.apartment,
                          title: "Join Organization",
                          subtitle: "Log in to your school or company",
                        ),
                        StepItem(
                          icon: Icons.location_pin,
                          title: "Take Attendance",
                          subtitle: "Check in with your biometrics",
                        ),
                      ],
                    ),

                    verticalSpace(size.height * 0.09),

                    /// BUTTON
                    CustomAppButton(
                      backgroundColor: AppColors.mainTextColorBlack,
                      child: Text(
                        "Start Registration",
                        style: TextStyle(
                          color: AppColors.backGroundColorWhite,
                          fontWeight: FontWeightHelper.semiBold,
                          fontSize: 15.sp,
                        ),
                      ),
                      onPressed: () {
                        context.pushNamed(Routes.scanIdScreen);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
