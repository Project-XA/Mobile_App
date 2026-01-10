import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/Data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/auth_state_service.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/services/toast_service.dart';
import 'package:mobile_app/feature/register/presentation/logic/register_cubit.dart';
import 'package:mobile_app/feature/register/presentation/logic/register_state.dart';
import 'package:mobile_app/feature/register/presentation/widgets/register_form_firld.dart';
import 'package:mobile_app/feature/register/presentation/widgets/register_submit_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _orgIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _orgIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        final localDataSource = getIt<UserLocalDataSource>();
        final localUserData = await localDataSource.getCurrentUser();

        if (!mounted) return;

        await context.read<RegisterCubit>().register(
          orgId: _orgIdController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          localUserData: localUserData,
        );
      } catch (e) {
        if (!mounted) return;

        showToast(
          message: 'Failed to get user data: ${e.toString()}',
          type: ToastType.error,
        );
      }
    }
  }

  void _handleSuccess(RegisterLoadedState state) async {
    final userRole = state.user.organizations?.first.role ?? 'User';

    try {
      final authStateService = getIt<AuthStateService>();
      await authStateService.markRegistrationComplete(userRole);
    } catch (e) {
      debugPrint('Failed to save registration state: $e');
    }

    if (!mounted) return;

    showToast(
      message:
          'Registered successfully as ${state.user.organizations?.first.role}',
      type: ToastType.success,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.pushReplacmentNamed(Routes.mainNavigation, arguments: userRole);
    });
  }

  void _handleError(String message) {
    showToast(message: message, type: ToastType.error);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoadedState) {
          _handleSuccess(state);
        } else if (state is RegisterFailureState) {
          _handleError(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoadingState;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegisterFormFields(
                orgIdController: _orgIdController,
                emailController: _emailController,
                passwordController: _passwordController,
              ),
              verticalSpace(20.h),
              RegisterSubmitButton(
                isLoading: isLoading,
                onPressed: _handleRegister,
              ),
            ],
          ),
        );
      },
    );
  }
}
