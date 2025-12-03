import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_app/core/themes/app_colors.dart';


class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;
          bool isLargeScreen = constraints.maxWidth > 900;

          double logoSize = isLargeScreen
              ? 450
              : isTablet
              ? 400
              : 300;

          double textFont = isTablet ? 18 : 15;

          log(logoSize);
          log(textFont);

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 48.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.05),

               // Image.asset(),
                  SizedBox(height: size.height * 0.04),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
