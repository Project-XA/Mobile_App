import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';

sealed class RegisterState {}

final class RegisterInitialState extends RegisterState {}

final class RegisterLoadingState extends RegisterState {}

final class RegisterLoadedState extends RegisterState {
  final UserModel user;
  
  RegisterLoadedState({required this.user});
}

final class RegisterFailureState extends RegisterState {
  final String message;
  final ApiErrorType? errorType; 
  
  RegisterFailureState({
    required this.message,
    this.errorType,
  });
  
  bool get isNetworkError =>
      errorType == ApiErrorType.connectionError ||
      errorType == ApiErrorType.connectionTimeout ||
      errorType == ApiErrorType.sendTimeout ||
      errorType == ApiErrorType.receiveTimeout;
  
  bool get isServerError => errorType == ApiErrorType.badResponse;
}