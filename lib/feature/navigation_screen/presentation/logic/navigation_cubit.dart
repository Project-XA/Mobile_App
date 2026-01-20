import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/feature/navigation_screen/presentation/logic/navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final UserLocalDataSource localDataSource;

  NavigationCubit({required this.localDataSource}) 
      : super(NavigationInitial());

  Future<void> determineNavigation() async {
    try {
      emit(NavigationLoading());
      
      final userModel = await localDataSource.getCurrentUser();
      final user = userModel.toEntity();
      
      if (!user.isRegistered || 
          user.organizations == null || 
          user.organizations!.isEmpty) {
        throw Exception('User is not registered in any organization');
      }
      
      final role = user.organizations!.first.role;
      
      emit(NavigationToMainScreen(role));
      
    } catch (e) {
      emit(NavigationError(e.toString()));
    }
  }
}