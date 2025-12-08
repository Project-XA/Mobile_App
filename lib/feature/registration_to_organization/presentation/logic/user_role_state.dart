part of 'user_role_cubit.dart';

abstract class UserRoleState {}

final class UserRoleInitial extends UserRoleState {}

final class UserRoleLoading extends UserRoleState {}

final class UserRoleSuccess extends UserRoleState {
  final String role;

  UserRoleSuccess(this.role);
}

final class UserRoleFailure extends UserRoleState {
  final String error;

  UserRoleFailure(this.error);
}