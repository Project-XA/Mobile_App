import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/session_form_field.dart';

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

  TimeOfDay? _selectedTime;
  String? _selectedWifiOption = 'WiFi';

  @override
  void dispose() {
    _sessionNameController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _handleStartSession() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select session start time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AdminCubit>().createAndStartSession(
      name: _sessionNameController.text.trim(),
      location: _locationController.text.trim(),
      connectionMethod: _selectedWifiOption ?? 'WiFi',
      startTime: _selectedTime!,
      durationMinutes: int.parse(_durationController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is SessionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is SessionState && state.isActive) {
          return const SizedBox.shrink();
        }

        final isLoading = state is SessionState && state.isLoading;

        return Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(20.h),

                SessionFormFields(
                  sessionNameController: _sessionNameController,
                  locationController: _locationController,
                  durationController: _durationController,
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
