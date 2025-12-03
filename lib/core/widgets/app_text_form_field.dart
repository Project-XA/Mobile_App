import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintText;
  final Widget? suffixIcon;

  final double borderRadius;
  final Color focusedBorderColor;
  final Color enabledBorderColor;

  final bool obscureText;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  final EdgeInsetsGeometry? contentPadding;

  final TextEditingController? controller;
  final String? Function(String?)? validator;

  final Widget? label;
  final TextStyle? labelStyle;

  const AppTextFormField({
    super.key,
    this.hintText,
    this.suffixIcon,
    required this.borderRadius,
    required this.focusedBorderColor,
    required this.enabledBorderColor,
    this.obscureText = false,
    this.contentPadding,
    this.textStyle,
    this.backgroundColor,
    this.controller,
    this.validator,
    this.label,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      style: textStyle,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor ?? Colors.white,
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),

        // Borders
        enabledBorder: textFieldBorder(borderRadius, enabledBorderColor),
        focusedBorder: textFieldBorder(borderRadius, focusedBorderColor),
        errorBorder: textFieldBorder(borderRadius, Colors.red),
        focusedErrorBorder: textFieldBorder(borderRadius, Colors.red),
        border: textFieldBorder(borderRadius, enabledBorderColor),

        // Text / Icons
        hintText: hintText,
        suffixIcon: suffixIcon,

        // Label
        label: label,
        labelStyle: labelStyle,
      ),
    );
  }

  OutlineInputBorder textFieldBorder(double radius, Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: 1.3.w),
    );
  }
}
