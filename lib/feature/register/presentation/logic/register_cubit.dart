import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
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
   // final user=UserModel(nationalId: '12324124124', firstNameAr:'عادل سعيد بع', lastNameAr: lastNameAr)

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
        final errorMessage = _getUserFriendlyMessage(error);
        emit(
          RegisterFailureState(message: errorMessage, errorType: error.type),
        );
      },
    );
  }

  String _getUserFriendlyMessage(ApiErrorModel error) {
    switch (error.type) {
      case ApiErrorType.connectionError:
        return 'No internet connection.';

      case ApiErrorType.connectionTimeout:
      case ApiErrorType.sendTimeout:
      case ApiErrorType.receiveTimeout:
        return 'Connection timed out. Please check your internet and try again.';

      case ApiErrorType.badCertificate:
        return 'Security issue detected. Please try again later.';

      case ApiErrorType.badResponse:
        return _handleBadResponse(error);

      case ApiErrorType.cancel:
        return 'Request was cancelled. Please try again.';

      case ApiErrorType.unknown:
      case ApiErrorType.defaultError:
        return 'Something went wrong. Please try again.';
    }
  }

  String _handleBadResponse(ApiErrorModel error) {
    final statusCode = error.statusCode;

    if (error.message.isNotEmpty && !error.message.contains('Exception')) {
      if (error.message.toLowerCase().contains('organization') ||
          error.message.toLowerCase().contains('org')) {
        return 'Organization not found';
      }

      if (error.message.toLowerCase().contains('email')) {
        return 'Invalid Creadentials';
      }

      if (error.message.toLowerCase().contains('password')) {
        return 'Invalid Creadentials';
      }

      return error.message;
    }

    switch (statusCode) {
      case 400:
        return 'Invalid information provided. Please check your details.';
      case 401:
        return 'Invalid credentials. Please check your Organization ID.';
      case 403:
        return 'Access denied. Please contact your administrator.';
      case 404:
        return 'Organization not found. Please check your Organization ID.';
      case 409:
        return 'This email is already registered. Please use a different email.';
      case 422:
        return 'Invalid data format. Please check your information.';
      case 500:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return 'Registration failed. Please try again.';
    }
  }
}
