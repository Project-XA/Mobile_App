import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/curren_user/Data/models/user_model.dart';
import 'package:mobile_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:mobile_app/features/auth/presentation/logic/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(RegisterInitialState());

  Future<void> register({
    required String orgId,
    required String email,
    required String password,
    required UserModel localUserData,
  }) async {
    emit(RegisterLoadingState());

    final result = await registerUseCase(
      orgId: orgId,
      email: email,
      password: password,
      localUserData: localUserData,
    );

    result.when(
      onSuccess: (user) {
        emit(RegisterLoadedState(user: user));
      },
      onError: (error) {
        emit(RegisterFailureState(error: error));
      },
    );
  }
}