import 'package:equatable/equatable.dart';
import 'package:mobile_app/core/curren_user/domain/entities/user.dart';

sealed class CurrentUserState extends Equatable {
  const CurrentUserState();
  @override
  List<Object?> get props => [];
}

final class CurrentUserInitial extends CurrentUserState {
  const CurrentUserInitial();
}

final class CurrentUserLoading extends CurrentUserState {
  const CurrentUserLoading();
}

final class CurrentUserLoaded extends CurrentUserState {
  final User user;
  const CurrentUserLoaded(this.user);
  @override
  List<Object?> get props => [user];
}

final class CurrentUserUpdating extends CurrentUserState {
  final User user;
  const CurrentUserUpdating(this.user);
  @override
  List<Object?> get props => [user];
}

final class CurrentUserUpdatingImage extends CurrentUserState {
  final User user;
  const CurrentUserUpdatingImage(this.user);
  @override
  List<Object?> get props => [user];
}

final class CurrentUserUpdated extends CurrentUserState {
  final User user;
  const CurrentUserUpdated(this.user);
  @override
  List<Object?> get props => [user];
}

final class CurrentUserImageUpdated extends CurrentUserState {
  final User user;
  const CurrentUserImageUpdated(this.user);
  @override
  List<Object?> get props => [user];
}

final class CurrentUserError extends CurrentUserState {
  final String message;
  const CurrentUserError(this.message);
  @override
  List<Object?> get props => [message];
}