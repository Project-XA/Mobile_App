import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/curren_user/Data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/auth/onboarding_service.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/curren_user/Data/models/user_model.dart';
import 'package:mobile_app/features/auth/presentation/logic/register_cubit.dart';
import 'package:mobile_app/features/auth/presentation/logic/register_state.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_form_firld.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_submit_button.dart';

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
        // final user = UserModel(
        //   nationalId: '123456667',
        //   firstNameAr: 'عادل',
        //   lastNameAr: 'محمد',
        //   address: 'أسيوط - مصر',
        //   birthDate: '1999-05-10',
        //   profileImage: null,
        // );

        if (!mounted) return;

        await context.read<RegisterCubit>().register(
          orgId: _orgIdController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          localUserData: localUserData,
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get user data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleSuccess(RegisterLoadedState state) async {
    final userRole = state.user.organizations?.first.role ?? 'User';

    try {
      final onboardingService = getIt<OnboardingService>();
      await onboardingService.markOnboardingComplete(userRole);
    } catch (e) {
      debugPrint('Failed to save onboarding state: $e');
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Registered successfully as ${state.user.organizations?.first.role}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.pushReplacmentNamed(Routes.mainNavigation, arguments: userRole);
    });
  }

  void _handleError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
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
