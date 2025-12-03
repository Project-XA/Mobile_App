import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? borderRadius;

  final double? paddingHorizontal;
  final double? paddingVertical;

  final double? width;
  final double? height;

  final BorderSide? borderSide;

  const CustomAppButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.textStyle,
    this.borderRadius,
    this.paddingHorizontal,
    this.paddingVertical,
    this.width,
    this.height,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 16),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        backgroundColor:
            WidgetStatePropertyAll(backgroundColor ?? Colors.white),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: (paddingHorizontal ?? 12).w,
            vertical: (paddingVertical ?? 14).h,
          ),
        ),
        fixedSize: WidgetStatePropertyAll(
          Size(
            width?.w ?? double.maxFinite,
            height?.h ?? 50.h,
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
