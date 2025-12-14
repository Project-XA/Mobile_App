sealed class RegisterState {}

final class RegisterInitialState extends RegisterState {}

final class RegisterLoadingState extends RegisterState {}

final class RegisterLoadedState extends RegisterState {
  final String userRole;
  RegisterLoadedState({required this.userRole});
}

final class RegisterFailureState extends RegisterState {
  final String message;
  RegisterFailureState({required this.message});
}