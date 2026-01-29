import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/services/UI/toast_service.dart';
import 'package:mobile_app/core/services/location/location_helper.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_cubit.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_state.dart';
import 'package:mobile_app/features/session_mangement/presentation/widgets/session_form_field.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateSessionForm extends StatefulWidget {
  const CreateSessionForm({super.key});

  @override
  State<CreateSessionForm> createState() => _CreateSessionFormState();
}

class _CreateSessionFormState extends State<CreateSessionForm> {
  final _formKey = GlobalKey<FormState>();
  final _sessionNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _durationController = TextEditingController(text: '60');
  final _allowedRadiusController = TextEditingController(text: '50');

  TimeOfDay? _selectedTime;
  String? _selectedWifiOption = 'WiFi';

  @override
  void dispose() {
    _sessionNameController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _allowedRadiusController.dispose();
    super.dispose();
  }

  void _handleStartSession() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTime == null) {
      showToast(message: 'Please select a time', type: ToastType.error);
      return;
    }

    final locationStatus = await LocationHelper.check();

    if (locationStatus == LocationStatus.serviceDisabled) {
      _showLocationSettingsDialog();
      return;
    }

    if (locationStatus == LocationStatus.deniedForever) {
      _showAppSettingsDialog();
      return;
    }

    // ignore: use_build_context_synchronously
    context.read<SessionMangementCubit>().createAndStartSession(
      name: _sessionNameController.text.trim(),
      location: _locationController.text.trim(),
      connectionMethod: _selectedWifiOption ?? 'WiFi',
      startTime: _selectedTime!,
      durationMinutes: int.parse(_durationController.text.trim()),
      allowedRadius: double.parse(_allowedRadiusController.text.trim()),
    );
  }

  void _showLocationSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backGroundColorWhite,
        title: const Text(
          'Location Services Disabled',
          style: TextStyle(
            color: AppColors.mainTextColorBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Location services are required to create a session. Please enable location services in your device settings.',
          style: TextStyle(color: AppColors.subTextColorGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.subTextColorGrey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainTextColorBlack,
              foregroundColor: AppColors.backGroundColorWhite,
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showAppSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'Location permission is permanently denied. Please enable it in app settings to create a session.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkErrorBanner() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.shade300, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.red, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No Internet Connection',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: Colors.red.shade900,
                  ),
                ),
                verticalSpace(4.h),
                Text(
                  'Please check your internet connection and try again.',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    fontSize: 13.sp,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionMangementCubit, SessionManagementState>(
      listener: (context, state) {
        if (state is SessionError) {
          if (!state.error.isNetworkError) {
            showToast(message: state.error.message, type: ToastType.error);
          }
        }
      },
      builder: (context, state) {
        if (state is SessionState && state.isActive) {
          return const SizedBox.shrink();
        }

        final isLoading = state is SessionState && state.isLoading;
        final showNetworkError = state is SessionError && state.isNetworkError;

        return Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(20.h),

                if (showNetworkError) _buildNetworkErrorBanner(),

                SessionFormFields(
                  sessionNameController: _sessionNameController,
                  locationController: _locationController,
                  durationController: _durationController,
                  allowedRadiusController: _allowedRadiusController,
                  initialTime: _selectedTime,
                  initialWifiOption: _selectedWifiOption,
                  onTimeSelected: (time) {
                    setState(() => _selectedTime = time);
                  },
                  onWifiOptionChanged: (option) {
                    setState(() => _selectedWifiOption = option);
                  },
                ),

                verticalSpace(25.h),

                CustomAppButton(
                  onPressed: isLoading ? null : _handleStartSession,
                  backgroundColor: isLoading
                      ? Colors.grey
                      : AppColors.mainTextColorBlack,
                  borderRadius: 20.r,
                  width: double.infinity,
                  height: 45.h,
                  child: isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Start Session',
                          style: AppTextStyle.font14MediamGrey.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeightHelper.medium,
                            fontSize: 16.sp,
                          ),
                        ),
                ),

                verticalSpace(20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
