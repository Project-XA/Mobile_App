import 'package:mobile_app/feature/home/domain/entities/user.dart';

sealed class CurrentUserState {
  const CurrentUserState();
}

class CurrentUserInitial extends CurrentUserState {
  const CurrentUserInitial();
}

class CurrentUserLoading extends CurrentUserState {
  const CurrentUserLoading();
}

class CurrentUserLoaded extends CurrentUserState {
  final User user;
  const CurrentUserLoaded(this.user);
}

class CurrentUserError extends CurrentUserState {
  final String message;
  const CurrentUserError(this.message);
}