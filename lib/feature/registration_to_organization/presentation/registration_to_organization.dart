import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/extensions.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/feature/registration_to_organization/data/repo_imp/registration_to_organization_repo_imp.dart';
import 'package:mobile_app/feature/registration_to_organization/presentation/logic/user_role_cubit.dart';
import 'package:mobile_app/feature/registration_to_organization/presentation/widgets/email_field.dart';
import 'package:mobile_app/feature/registration_to_organization/presentation/widgets/organization_id_field.dart';
import 'package:mobile_app/feature/registration_to_organization/presentation/widgets/password_field.dart';
import 'package:mobile_app/feature/registration_to_organization/presentation/widgets/registration_header.dart';
import 'package:mobile_app/feature/registration_to_organization/presentation/widgets/request_access_button.dart';

class RegistrationToOrganization extends StatefulWidget {
  const RegistrationToOrganization({super.key});

  @override
  State<RegistrationToOrganization> createState() =>
      _RegistrationToOrganizationState();
}

class _RegistrationToOrganizationState
    extends State<RegistrationToOrganization> {
  final TextEditingController _organizationIdController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _organizationIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserRoleCubit(
        RegistrationToOrganizationRepoImp(NetworkServiceImp()),
      ),
      child: BlocListener<UserRoleCubit, UserRoleState>(
        listener: (context, state) {
          if (state is UserRoleSuccess) {
            context.pushReplacmentNamed(
              Routes.homePage,
              arguments: state.role,
            );
          } else if (state is UserRoleFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.backGroundColorWhite,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const RegistrationHeader(),
                      OrganizationIdField(
                        controller: _organizationIdController,
                      ),
                      EmailField(
                        controller: _emailController,
                      ),
                      PasswordField(
                        controller: _passwordController,
                      ),
                      RequestAccessButton(
                        organizationIdController: _organizationIdController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

