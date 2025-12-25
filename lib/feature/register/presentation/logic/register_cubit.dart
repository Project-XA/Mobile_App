import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:mobile_app/feature/register/domain/use_cases/register_use_case.dart';
import 'package:mobile_app/feature/register/presentation/logic/register_state.dart';

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
        emit(RegisterFailureState(message: error.toString()));
      },
    );
  }
}
