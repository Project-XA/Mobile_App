// presentation/logic/user_profile_cubit.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/usecases/get_current_user_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/usecases/update_user_profile_image.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/usecases/update_user_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/logic/user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateUserProfileImage updateUserProfileImage;
  final UpdateUserUseCase updateUserUseCase;

  User? _currentUser;
  User? get currentUser => _currentUser;

  UserProfileCubit(
    this.getCurrentUserUseCase,
    this.updateUserProfileImage,
    this.updateUserUseCase,
  ) : super(UserProfileInitial());

  Future<void> loadUser() async {
    try {
      emit(UserProfileLoading());
      final user = await getCurrentUserUseCase.getCurrentUser();
      // final user = User(
      //   nationalId: '123456667',
      //   firstNameAr: 'عادل',
      //   lastNameAr: 'محمد',
      //   address: 'أسيوط - مصر',
      //   birthDate: '1999-05-10',
      //   email: 'adel@gmail.com',
      //   firstNameEn: 'Adel',
      //   lastNameEn: 'Mohamed',
      //   organizations: [UserOrg(orgId: '1234', role: 'admin')],
      //   profileImage: null,
      // );

      _currentUser = user;
      emit(UserProfileLoaded(user));
    } catch (e) {
      emit(UserProfileFailure(e.toString()));
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    if (_currentUser == null) {
      emit(UserProfileFailure('no data'));
      return;
    }

    try {
      emit(ProfileImageUpdating());

      await updateUserProfileImage.updateprofileImage(imageFile);

      final updatedUser = await getCurrentUserUseCase.getCurrentUser();
      _currentUser = updatedUser;

      emit(ProfileImageUpdated(updatedUser.profileImage ?? ''));
      emit(UserProfileLoaded(updatedUser));
    } catch (e) {
      emit(UserProfileFailure(' Update image failed: ${e.toString()}'));
      if (_currentUser != null) {
        emit(UserProfileLoaded(_currentUser!));
      }
    }
  }

  Future<void> updateUser({
    String? firstNameAr,
    String? lastNameAr,
    String? address,
    String? email,
  }) async {
    if (_currentUser == null) {
      emit(UserProfileFailure('no user data '));
      return;
    }

    try {
      emit(ProfileUpdating());

      final updatedUser = User(
        nationalId: _currentUser!.nationalId,
        firstNameAr: firstNameAr ?? _currentUser!.firstNameAr,
        lastNameAr: lastNameAr ?? _currentUser!.lastNameAr,
        address: address ?? _currentUser!.address,
        birthDate: _currentUser!.birthDate,
        email: email ?? _currentUser!.email,
        firstNameEn: _currentUser!.firstNameEn,
        lastNameEn: _currentUser!.lastNameEn,
        organizations: _currentUser!.organizations,
        profileImage: _currentUser!.profileImage,
      );

      await updateUserUseCase.updateUserUseCase(updatedUser);

      _currentUser = updatedUser;
      emit(ProfileUpdated(updatedUser));
      emit(UserProfileLoaded(updatedUser));
    } catch (e) {
      emit(UserProfileFailure('update failed: ${e.toString()}'));
      if (_currentUser != null) {
        emit(UserProfileLoaded(_currentUser!));
      }
    }
  }

  @override
  Future<void> close() {
    _currentUser = null;
    return super.close();
  }
}
