import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class ToggleTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color backgroundColor;

  const ToggleTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.selectedColor = AppColors.mainTextColorBlack,
    this.unselectedColor = Colors.transparent,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.black87,
    this.backgroundColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16.w : 20.w,
                vertical: isSmallScreen ? 8.h : 10.h,
              ),
              decoration: BoxDecoration(
                color: isSelected ? selectedColor : unselectedColor,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: selectedColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  fontSize: isSmallScreen ? 13.sp : 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}