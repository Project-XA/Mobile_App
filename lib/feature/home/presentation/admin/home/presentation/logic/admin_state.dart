sealed class AdminState {}

final class AdminInitial extends AdminState {}

final class AdminLoading extends AdminState {}

final class AdminLoaded extends AdminState {}

final class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}

final class ToggleTabChanged extends AdminState {
  final int selectedIndex;
  ToggleTabChanged(this.selectedIndex);
}