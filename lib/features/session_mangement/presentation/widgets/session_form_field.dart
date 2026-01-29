import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';

class SessionFormFields extends StatefulWidget {
  final TextEditingController sessionNameController;
  final TextEditingController locationController;
  final TextEditingController durationController;
  final TextEditingController allowedRadiusController;
  final TimeOfDay? initialTime;
  final String? initialWifiOption;
  final Function(TimeOfDay) onTimeSelected;
  final Function(String?) onWifiOptionChanged;

  const SessionFormFields({
    super.key,
    required this.sessionNameController,
    required this.locationController,
    required this.durationController,
    required this.allowedRadiusController,
    this.initialTime,
    this.initialWifiOption,
    required this.onTimeSelected,
    required this.onWifiOptionChanged,
  });

  @override
  State<SessionFormFields> createState() => _SessionFormFieldsState();
}

class _SessionFormFieldsState extends State<SessionFormFields> {
  static const List<String> _wifiOptions = [
    'WiFi',
    'Bluetooth',
    'NFC',
    'QR Code',
  ];

  late TimeOfDay? _selectedTime;
  late String? _selectedWifiOption;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _selectedWifiOption = widget.initialWifiOption ?? 'WiFi';
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
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

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSessionNameField(),
        verticalSpace(15.h),

        _buildLocationField(),
        verticalSpace(15.h),

        _buildWifiDropdown(),
        verticalSpace(15.h),

        _buildTimePicker(context),
        verticalSpace(15.h),

        _buildDurationField(),
        verticalSpace(15.h),

        _buildAllowedRadiusField(),
      ],
    );
  }

  Widget _buildSessionNameField() {
    return AppTextFormField(
      borderRadius: 20.r,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      focusedBorderColor: AppColors.mainTextColorBlack,
      enabledBorderColor: Colors.grey,
      controller: widget.sessionNameController,
      hintText: "Enter session name",
      labelStyle: AppTextStyle.font14MediamGrey,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Session name is required';
        }
        return null;
      },
    );
  }

  Widget _buildLocationField() {
    return AppTextFormField(
      borderRadius: 20.r,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      focusedBorderColor: AppColors.mainTextColorBlack,
      enabledBorderColor: Colors.grey,
      controller: widget.locationController,
      hintText: "Enter location name (e.g., Room 101, Main Hall)",
      labelStyle: AppTextStyle.font14MediamGrey,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Location is required';
        }
        return null;
      },
    );
  }

  Widget _buildWifiDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              value: _selectedWifiOption,
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
              onChanged: (option) {
                if (option != null && option != _selectedWifiOption) {
                  setState(() {
                    _selectedWifiOption = option;
                  });
                  widget.onWifiOptionChanged(option);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  _selectedTime == null
                      ? '--:-- --'
                      : _selectedTime!.format(context),
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    color: _selectedTime == null
                        ? Colors.grey
                        : AppColors.mainTextColorBlack,
                  ),
                ),
                Icon(Icons.access_time, color: Colors.grey, size: 20.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          controller: widget.durationController,
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

  Widget _buildAllowedRadiusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ALLOWED RADIUS (METERS)',
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
          controller: widget.allowedRadiusController,
          hintText: "50",
          keyboardType: TextInputType.number,
          labelStyle: AppTextStyle.font14MediamGrey,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Allowed radius is required';
            }
            final radius = double.tryParse(value);
            if (radius == null || radius <= 0) {
              return 'Please enter a valid radius';
            }
            return null;
          },
        ),
      ],
    );
  }
}
