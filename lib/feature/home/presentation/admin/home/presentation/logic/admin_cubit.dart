import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(ToggleTabChanged(0));

  void changeTab(int index) {
    emit(ToggleTabChanged(index));
  }

  int getSelectedIndex() {
    if (state is ToggleTabChanged) {
      return (state as ToggleTabChanged).selectedIndex;
    }
    return 0;
  }
}
