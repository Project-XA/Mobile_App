import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/registration_to_organization/domain/repo/registration_to_organization_repo.dart';

part 'user_role_state.dart';

class UserRoleCubit extends Cubit<UserRoleState> {
  final RegistrationToOrganizationRepo _repo;

  UserRoleCubit(this._repo) : super(UserRoleInitial());

  Future<void> getUserRole({
    required String organizationCode,
    required String email,
    required String password,
  }) async {
    emit(UserRoleLoading());

    final result = await _repo.getUserRole(
      organizationCode,
      email,
      password,
    );

    result.when(
      onSuccess: (role) {
        emit(UserRoleSuccess(role));
      },
      onError: (error) {
        emit(UserRoleFailure(error.toString()));
      },
    );
  }
}
