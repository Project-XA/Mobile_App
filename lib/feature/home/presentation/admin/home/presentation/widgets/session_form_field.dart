import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';

class SessionFormFields extends StatelessWidget {
  final TextEditingController sessionNameController;
  final TextEditingController locationController;
  final TextEditingController durationController;
  final TimeOfDay? selectedTime;
  final String? selectedWifiOption;
  final Function(TimeOfDay) onTimeSelected;
  final Function(String?) onWifiOptionChanged;

  const SessionFormFields({
    super.key,
    required this.sessionNameController,
    required this.locationController,
    required this.durationController,
    required this.selectedTime,
    required this.selectedWifiOption,
    required this.onTimeSelected,
    required this.onWifiOptionChanged,
  });

  final List<String> _wifiOptions = const [
    'WiFi',
    'Bluetooth',
    'NFC',
    'QR Code',
  ];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.mainTextColorBlack,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Session Name Field
        AppTextFormField(
          borderRadius: 20.r,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 15.h,
          ),
          focusedBorderColor: AppColors.mainTextColorBlack,
          enabledBorderColor: Colors.grey,
          controller: sessionNameController,
          hintText: "Enter session name",
          labelStyle: AppTextStyle.font14MediamGrey,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Session name is required';
            }
            return null;
          },
        ),

        verticalSpace(15.h),

        // Location Field
        AppTextFormField(
          borderRadius: 20.r,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 15.h,
          ),
          focusedBorderColor: AppColors.mainTextColorBlack,
          enabledBorderColor: Colors.grey,
          controller: locationController,
          hintText: "Enter location name (e.g., Room 101, Main Hall)",
          labelStyle: AppTextStyle.font14MediamGrey,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Location is required';
            }
            return null;
          },
        ),

        verticalSpace(15.h),

        // WiFi/Connection Method Dropdown
        Text(
          'CONNECTION METHOD',
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontWeight: FontWeightHelper.semiBold,
            fontSize: 12.sp,
          ),
        ),
        verticalSpace(8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedWifiOption,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              style: AppTextStyle.font14MediamGrey.copyWith(
                color: AppColors.mainTextColorBlack,
              ),
              items: _wifiOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onWifiOptionChanged,
            ),
          ),
        ),

        verticalSpace(15.h),

        Text(
          'SESSION START TIME',
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontWeight: FontWeightHelper.semiBold,
            fontSize: 12.sp,
          ),
        ),
        verticalSpace(8.h),
        InkWell(
          onTap: () => _selectTime(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedTime == null
                      ? '--:-- --'
                      : selectedTime!.format(context),
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    color: selectedTime == null
                        ? Colors.grey
                        : AppColors.mainTextColorBlack,
                  ),
                ),
                Icon(Icons.access_time, color: Colors.grey, size: 20.sp),
              ],
            ),
          ),
        ),

        verticalSpace(15.h),

        // Session Duration
        Text(
          'SESSION DURATION (MINUTES)',
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontWeight: FontWeightHelper.semiBold,
            fontSize: 12.sp,
          ),
        ),
        verticalSpace(8.h),
        AppTextFormField(
          borderRadius: 20.r,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 15.h,
          ),
          focusedBorderColor: AppColors.mainTextColorBlack,
          enabledBorderColor: Colors.grey,
          controller: durationController,
          hintText: "60",
          keyboardType: TextInputType.number,
          labelStyle: AppTextStyle.font14MediamGrey,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Duration is required';
            }
            final duration = int.tryParse(value);
            if (duration == null || duration <= 0) {
              return 'Please enter a valid duration';
            }
            return null;
          },
        ),
      ],
    );
  }
}
